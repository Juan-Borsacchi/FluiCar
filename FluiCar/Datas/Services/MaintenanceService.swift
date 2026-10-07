//
//  MaintenanceService.swift
//  FluiCar
//
//  Created by Isabella Avelina on 01/10/26.
//

import Foundation
import Observation
import os

@MainActor
@Observable
final class MaintenanceService {
    static let shared = MaintenanceService()

    private(set) var cars: [CarModel] = []
    private(set) var automaticTasks: [AutomaticTask] = []
    private(set) var customTasks: [CustomTaskModel] = []
    private(set) var hasLoaded = false
    private(set) var loadFailed = false

    var hasCars: Bool { !cars.isEmpty }

    private let repository: any VehicleRepositoryProtocol
    private let storage: any MaintenanceStorageProtocol
    private let scheduler: any ReminderSchedulerProtocol
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "FluiCar",
        category: "MaintenanceService"
    )

    init(
        repository: (any VehicleRepositoryProtocol)? = nil,
        storage: any MaintenanceStorageProtocol = UserDefaultsMaintenanceStorage(),
        scheduler: any ReminderSchedulerProtocol = NotificationReminderScheduler()
    ) {
        self.repository = repository ?? DataService.shared
        self.storage = storage
        self.scheduler = scheduler
    }

    // MARK: - Carregamento

    func load() async {
        do {
            cars = try await repository.fetchAll()
            loadFailed = false
        } catch {
            logger.error("Falha ao carregar veículos: \(error.localizedDescription, privacy: .public)")
            loadFailed = true
            hasLoaded = true
            return
        }

        synchronizeTasks()
        hasLoaded = true
    }

    /// Garante que cada carro tenha suas tarefas automáticas e remove as de carros apagados.
    private func synchronizeTasks() {
        let carIDs = Set(cars.map(\.id))
        let storedAutomatic = storage.loadAutomaticTasks()
        let storedCustom = storage.loadCustomTasks()

        let orphanReminderIDs =
            storedAutomatic.filter { !carIDs.contains($0.carID) }.map { automaticReminderID($0.id) } +
            storedCustom.filter { !carIDs.contains($0.vehicleID) }.map { customReminderID($0.id) }
        if !orphanReminderIDs.isEmpty {
            scheduler.cancel(ids: orphanReminderIDs)
        }

        var automatic = storedAutomatic.filter { carIDs.contains($0.carID) }
        var created: [AutomaticTask] = []

        for car in cars {
            for type in TaskType.automaticTypes {
                let alreadyExists = automatic.contains { $0.carID == car.id && $0.type == type }
                guard !alreadyExists else { continue }

                let task = AutomaticTask(
                    id: UUID(),
                    carID: car.id,
                    type: type,
                    dueDate: type.nextDueDate(after: Date()),
                    lastCheckDate: nil,
                    selectedOption: nil
                )
                automatic.append(task)
                created.append(task)
            }
        }

        automaticTasks = automatic
        customTasks = storedCustom.filter { carIDs.contains($0.vehicleID) }

        storage.saveAutomaticTasks(automaticTasks)
        storage.saveCustomTasks(customTasks)

        for task in created {
            scheduleReminder(for: task)
        }

        // Lembretes semestrais disparam uma vez só: reagenda a próxima ocorrência.
        for task in customTasks where task.frequency == .semiannual {
            scheduleReminder(for: task)
        }
    }

    // MARK: - Consultas

    func carName(for id: UUID) -> String? {
        cars.first { $0.id == id }?.name
    }

    func automaticTask(id: UUID) -> AutomaticTask? {
        automaticTasks.first { $0.id == id }
    }

    func customTask(id: UUID) -> CustomTaskModel? {
        customTasks.first { $0.id == id }
    }

    func automaticRow(for task: AutomaticTask) -> MaintenanceRow? {
        guard let name = carName(for: task.carID) else { return nil }
        return MaintenanceRow(task: task, vehicleName: name)
    }

    func customRow(for task: CustomTaskModel) -> MaintenanceRow? {
        guard let name = carName(for: task.vehicleID) else { return nil }
        return MaintenanceRow(task: task, vehicleName: name)
    }

    /// Próximas tarefas de um carro (automáticas + customizadas), da mais próxima para a mais distante.
    func upcomingRows(for carID: UUID, limit: Int) -> [MaintenanceRow] {
        let automatic = automaticTasks
            .filter { $0.carID == carID }
            .compactMap { automaticRow(for: $0) }
        let custom = customTasks
            .filter { $0.vehicleID == carID }
            .compactMap { customRow(for: $0) }

        let sorted = (automatic + custom).sorted {
            ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture)
        }
        return Array(sorted.prefix(limit))
    }

    // MARK: - Alterações

    func complete(automaticTaskID id: UUID) {
        guard let index = automaticTasks.firstIndex(where: { $0.id == id }) else { return }
        let today = Date()
        automaticTasks[index].lastCheckDate = today
        automaticTasks[index].dueDate = automaticTasks[index].type.nextDueDate(after: today)
        commitAutomaticChange(at: index)
    }

    func updateAutomaticTask(id: UUID, selectedOption: String, lastCheckDate: Date, dueDate: Date) {
        guard let index = automaticTasks.firstIndex(where: { $0.id == id }) else { return }
        automaticTasks[index].selectedOption = selectedOption
        automaticTasks[index].lastCheckDate = lastCheckDate
        automaticTasks[index].dueDate = dueDate
        commitAutomaticChange(at: index)
    }

    func saveCustomTask(_ task: CustomTaskModel) {
        if let index = customTasks.firstIndex(where: { $0.id == task.id }) {
            customTasks[index] = task
        } else {
            customTasks.append(task)
        }
        storage.saveCustomTasks(customTasks)
        scheduleReminder(for: task)
    }

    /// Mantém a tarefa "Seguro" do carro alinhada com o cadastro do veículo:
    /// cria/atualiza quando o carro tem seguro e remove quando deixa de ter.
    func syncInsuranceTask(for car: CarModel) async {
        // Garante que o carro recém-salvo já esteja na lista (o lembrete precisa do nome dele).
        await load()
        guard !loadFailed else { return }

        let existing = customTasks.first { $0.vehicleID == car.id && $0.isInsurance == true }

        guard car.insurance == true else {
            if let existing { deleteCustomTask(id: existing.id) }
            return
        }

        saveCustomTask(
            CustomTaskModel(
                id: existing?.id ?? UUID(),
                vehicleID: car.id,
                title: "Seguro",
                note: existing?.note ?? "Renovação do seguro do veículo.",
                alarmDate: insuranceAlarmDate(car.alarm ?? Date()),
                frequency: car.frequency.reminderRepeat,
                isInsurance: true
            )
        )
    }

    /// O cadastro só pede a data; o lembrete dispara às 9h desse dia.
    private func insuranceAlarmDate(_ date: Date) -> Date {
        Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: date) ?? date
    }

    func deleteCustomTask(id: UUID) {
        guard customTasks.contains(where: { $0.id == id }) else { return }
        customTasks.removeAll { $0.id == id }
        storage.saveCustomTasks(customTasks)
        scheduler.cancel(ids: [customReminderID(id)])
    }

    private func commitAutomaticChange(at index: Int) {
        storage.saveAutomaticTasks(automaticTasks)
        scheduleReminder(for: automaticTasks[index])
    }

    // MARK: - Lembretes

    private func automaticReminderID(_ id: UUID) -> String { "automatic-\(id.uuidString)" }
    private func customReminderID(_ id: UUID) -> String { "custom-\(id.uuidString)" }

    private func scheduleReminder(for task: AutomaticTask) {
        guard let carName = carName(for: task.carID) else { return }
        let scheduler = scheduler
        let id = automaticReminderID(task.id)
        let title = "Manutenção: \(task.type.maintenanceTitle)"
        let body = "O veículo \(carName) precisa de atenção."
        let date = task.dueDate

        Task {
            await scheduler.schedule(id: id, title: title, body: body, date: date, repeatRule: .never)
        }
    }

    private func scheduleReminder(for task: CustomTaskModel) {
        guard let carName = carName(for: task.vehicleID) else { return }
        let scheduler = scheduler
        let id = customReminderID(task.id)
        let title = "Lembrete: \(task.title)"
        let body = task.note.isEmpty ? "Veículo: \(carName)" : task.note
        let date = task.alarmDate
        let repeatRule = task.frequency

        Task {
            await scheduler.schedule(id: id, title: title, body: body, date: date, repeatRule: repeatRule)
        }
    }
}
