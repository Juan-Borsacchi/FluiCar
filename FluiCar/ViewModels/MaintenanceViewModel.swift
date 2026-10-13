//
//  MaintenanceViewModel.swift
//  FluiCar
//
//  Created by Isabella Avelina on 29/09/26.
//
import Foundation
import Observation

@MainActor
@Observable
final class MaintenanceViewModel {
    enum ScreenState {
        case loading
        case failed
        case noCars
        case content
    }

    enum PendingAction {
        case complete(MaintenanceRow)
        case delete(MaintenanceRow)

        var row: MaintenanceRow {
            switch self {
            case .complete(let row), .delete(let row): return row
            }
        }

        var title: String {
            switch self {
            case .complete: return "Concluir tarefa?"
            case .delete: return "Excluir tarefa?"
            }
        }

        var message: String {
            switch self {
            case .complete(let row):
                return "Tem certeza de que deseja concluir '\(row.title)'?"
            case .delete(let row):
                return "Tem certeza de que deseja excluir '\(row.title)'? Essa ação não pode ser desfeita."
            }
        }

        var isDelete: Bool {
            if case .delete = self { return true }
            return false
        }

        var confirmLabel: String {
            switch self {
            case .complete: return "Concluir"
            case .delete: return "Excluir"
            }
        }
    }

    private let service: MaintenanceService

    var selectedFilter: TaskFilter = .all
    var selectedStatus: MaintenanceStatusFilter = .all
    var isShowingAddSheet = false
    var isShowingAlert = false
    var isShowingConfirmation = false
    private(set) var pendingAction: PendingAction?
    private(set) var alertTitle = "Aviso"
    private(set) var alertMessage = ""

    init(service: MaintenanceService? = nil) {
        self.service = service ?? MaintenanceService.shared
    }


    var screenState: ScreenState {
        if !service.hasLoaded { return .loading }
        if service.loadFailed { return .failed }
        if !service.hasCars { return .noCars }
        return .content
    }

    var vehicles: [CarModel] { service.cars }
    var canAddTask: Bool { service.hasCars }

   
    private var selectedCarID: UUID? {
        if case .vehicle(let id) = selectedFilter { return id }
        return nil
    }

    var automaticRows: [MaintenanceRow] {
        sortedAutomaticTasks
            .filter { selectedCarID == nil || $0.carID == selectedCarID }
            .compactMap { service.automaticRow(for: $0) }
            .filter { selectedStatus.includes($0) }
    }

    var customRows: [MaintenanceRow] {
        service.cars
            .filter { selectedCarID == nil || $0.id == selectedCarID }
            .flatMap { $0.tasks }
            .filter { !$0.isAutomatic }
            .sorted { ($0.endDate ?? Date()) < ($1.endDate ?? Date()) }
            .map { MaintenanceRow(task: $0) }
            .filter { selectedStatus.includes($0) }
    }

    var hasVisibleRows: Bool { !automaticRows.isEmpty || !customRows.isEmpty }

    private var sortedAutomaticTasks: [AutomaticTask] {
        service.automaticTasks.sorted { $0.dueDate < $1.dueDate }
    }


    func load() async {
        await service.load()

        if let id = selectedCarID, !service.cars.contains(where: { $0.id == id }) {
            selectedFilter = .all
        }
    }

    func saveNewTask(_ task: CarTaskModel, to car: CarModel) {
            service.saveCustomTask(task, to: car)
            showAlert(title: "Tarefa criada", message: "A tarefa '\(task.title)' foi criada com sucesso!")
        }


    func requestComplete(_ row: MaintenanceRow) {
        pendingAction = .complete(row)
        isShowingConfirmation = true
    }

    func requestDelete(_ row: MaintenanceRow) {
        pendingAction = .delete(row)
        isShowingConfirmation = true
    }

    func cancelPendingAction() {
        pendingAction = nil
    }

    func confirmPendingAction() {
        guard let action = pendingAction else { return }
        pendingAction = nil

        Task {
            try? await Task.sleep(for: .milliseconds(400))
            switch action {
            case .complete(let row): complete(row)
            case .delete(let row): deleteCustomTask(row)
            }
        }
    }

   
    private func complete(_ row: MaintenanceRow) {
        switch row.ref {
        case .automatic(let id):
            completeAutomaticTask(id: id, title: row.title)
        case .custom:
            completeCustomTask(row)
        }
    }

    private func completeAutomaticTask(id: UUID, title: String) {
        guard service.automaticTask(id: id) != nil else { return }
        service.complete(automaticTaskID: id)
        showAlert(
            title: "Tarefa concluída!",
            message: "A manutenção '\(title)' foi registrada e a próxima data foi agendada."
        )
    }

    private func completeCustomTask(_ row: MaintenanceRow) {
        guard case .custom(let id) = row.ref,
              let car = service.cars.first(where: { $0.tasks.contains { $0.id == id } }),
              let task = car.tasks.first(where: { $0.id == id }) else { return }

        let rescheduled = service.completeCustomTask(task, in: car)
        showAlert(
            title: "Tarefa concluída!",
            message: rescheduled
                ? "A tarefa '\(row.title)' foi concluída e a próxima data foi agendada."
                : "A tarefa '\(row.title)' foi concluída e removida da lista."
        )
    }

    private func deleteCustomTask(_ row: MaintenanceRow) {
            guard case .custom(let id) = row.ref else { return }
            
            let allTasks = service.cars.flatMap { $0.tasks }
            guard let taskToDelete = allTasks.first(where: { $0.id == id }) else { return }
            
            service.deleteCustomTask(taskToDelete)
            
            showAlert(title: "Tarefa excluída", message: "A tarefa '\(row.title)' foi excluída.")
        }

    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        isShowingAlert = true
    }
}
