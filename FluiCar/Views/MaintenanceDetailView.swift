//
//  MaintenanceViewModel.swift
//  FluiCar
//
//  Created by Isabella Avelina on 29/09/26.
//

import Foundation
import SwiftUI
import Observation
import UserNotifications

@MainActor
@Observable
class MaintenanceViewModel {
    var tasks: [TaskItemModel] = []
    var customTasks: [CustomTaskModel] = []
    var isLoading = false
    var hasLoaded = false
    var hasCars = false
    var vehicleNames: [String] = []

    private static let customTasksKey = "customTasks"

    struct TaskItemModel: Identifiable {
        let id = UUID()
        let key: String
        let title: String
        let vehicle: String
        let dueDate: String
        let rawDate: Date
        let taskType: TaskType
    }

    init() {
        customTasks = Self.loadCustomTasks()
    }


    func addCustomTask(_ task: CustomTaskModel) {
        if let index = customTasks.firstIndex(where: { $0.id == task.id }) {
            customTasks[index] = task
        } else {
            customTasks.append(task)
        }

        saveCustomTasks()
        MaintenanceReminderService.schedule(customTask: task)
    }

    func deleteCustomTask(at offsets: IndexSet) {
        let ids = offsets.map { customTasks[$0].id }
        customTasks.remove(atOffsets: offsets)

        saveCustomTasks()
        ids.forEach { MaintenanceReminderService.cancel(customTaskID: $0) }
    }

    private func saveCustomTasks() {
        if let data = try? JSONEncoder().encode(customTasks) {
            UserDefaults.standard.set(data, forKey: Self.customTasksKey)
        }
    }

    private static func loadCustomTasks() -> [CustomTaskModel] {
        guard
            let data = UserDefaults.standard.data(forKey: customTasksKey),
            let tasks = try? JSONDecoder().decode([CustomTaskModel].self, from: data)
        else {
            return []
        }
        return tasks
    }

  

    func filteredTasks(for filter: String) -> [TaskItemModel] {
        switch filter {
        case "Prazo para vencer":
            return tasks.sorted { $0.rawDate < $1.rawDate }

        case "Manutenção recente":
            return tasks.sorted { $0.rawDate > $1.rawDate }

        default:
            return tasks
        }
    }

    

    func loadCarAndTasks() async {
        if !hasLoaded {
            isLoading = true
        }

        do {
            let cars = try await DataService.shared.fetchAll()

            hasCars = !cars.isEmpty
            vehicleNames = cars.map { $0.name.isEmpty ? $0.model : $0.name }
            fetchMaintenanceTasks(for: cars)
        } catch {
            print("Erro ao carregar veículos: \(error)")
            hasCars = false
            vehicleNames = []
            fetchMaintenanceTasks(for: [])
        }

     
        customTasks.forEach { MaintenanceReminderService.schedule(customTask: $0) }

        hasLoaded = true
    }

    func fetchMaintenanceTasks(for cars: [CarModel]) {
        guard !cars.isEmpty else {
            tasks = []
            isLoading = false
            MaintenanceReminderService.syncAutoTasks(validKeys: [])
            return
        }

        let calendar = Calendar.current
        let today = Date()

        func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            formatter.locale = Locale(identifier: "pt_BR")
            return formatter.string(from: date)
        }

        
        let templates: [(title: String, type: TaskType, due: Date)] = [
            ("Troca de óleo", .oilChange,
             calendar.date(byAdding: .month, value: 6, to: today) ?? today),
            ("Verificar a água do radiador", .waterCheck,
             calendar.date(byAdding: .day, value: 15, to: today) ?? today),
            ("Verificar pastilhas do freio", .brakeCheck,
             calendar.date(byAdding: .year, value: 1, to: today) ?? today),
            ("Testar estado da bateria", .batteryCheck,
             calendar.date(byAdding: .month, value: 8, to: today) ?? today),
            ("Calibrar pneus", .tireCalibration,
             calendar.date(byAdding: .day, value: 15, to: today) ?? today)
        ]

        var generatedTasks: [TaskItemModel] = []
        var validKeys = Set<String>()

        for car in cars {
            let vehicleName = car.name.isEmpty ? car.model : car.name

            for template in templates {
                let key = "task.\(car.id.uuidString).\(template.type.rawValue)"
                validKeys.insert(key)

                let due = MaintenanceReminderService.dueDate(
                    for: key,
                    default: template.due,
                    title: template.title,
                    vehicle: vehicleName
                )

                generatedTasks.append(
                    TaskItemModel(
                        key: key,
                        title: template.title,
                        vehicle: vehicleName,
                        dueDate: "Próxima: \(formatDate(due))",
                        rawDate: due,
                        taskType: template.type
                    )
                )
            }
        }

        tasks = generatedTasks
        isLoading = false
        MaintenanceReminderService.syncAutoTasks(validKeys: validKeys)
    }
}


@MainActor
final class NotificationService: NSObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()

    private override init() {
        super.init()
        center.delegate = self
    }

    func requestAuthorization() async {
        do {
            _ = try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Erro ao pedir permissão de notificação: \(error)")
        }
    }

    func send(id: String, title: String, body: String) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        do {
            try await center.add(request)
        } catch {
            print("Erro ao agendar notificação: \(error)")
        }
    }

    func schedule(
        id: String,
        title: String,
        body: String,
        components: DateComponents,
        repeats: Bool
    ) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        do {
            try await center.add(request)
        } catch {
            print("Erro ao agendar notificação: \(error)")
        }
    }

    func cancel(ids: [String]) {
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }

    func removeStale(prefix: String, keeping valid: Set<String>) async {
        let pending = await center.pendingNotificationRequests()
        let stale = pending
            .map(\.identifier)
            .filter { $0.hasPrefix(prefix) && !valid.contains($0) }
        center.removePendingNotificationRequests(withIdentifiers: stale)
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .list, .sound]
    }
}


enum MaintenanceReminderService {

    private static let autoPrefix = "task."

    
    nonisolated static func dueDate(
        for key: String,
        default defaultDate: Date,
        title: String,
        vehicle: String
    ) -> Date {
        let defaults = UserDefaults.standard
        let storageKey = "due.\(key)"

        let due: Date
        if let stored = defaults.object(forKey: storageKey) as? Date {
            due = stored
        } else {
            due = Calendar.current.date(
                bySettingHour: 9, minute: 0, second: 0, of: defaultDate
            ) ?? defaultDate
            defaults.set(due, forKey: storageKey)
        }

        scheduleAuto(key: key, title: title, vehicle: vehicle, date: due)
        return due
    }

    nonisolated static func storedDueDate(for key: String) -> Date? {
        UserDefaults.standard.object(forKey: "due.\(key)") as? Date
    }

    nonisolated static func setDueDate(_ date: Date, key: String, title: String, vehicle: String) {
        UserDefaults.standard.set(date, forKey: "due.\(key)")
        scheduleAuto(key: key, title: title, vehicle: vehicle, date: date)
    }

    nonisolated private static func scheduleAuto(key: String, title: String, vehicle: String, date: Date) {
        guard date > Date() else { return }

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute], from: date
        )

        Task { @MainActor in
            await NotificationService.shared.schedule(
                id: key,
                title: "\(title) · \(vehicle)",
                body: "Está na hora desta manutenção. Abra o FluiCar para ver o tutorial.",
                components: components,
                repeats: false
            )
        }
    }

    nonisolated static func syncAutoTasks(validKeys: Set<String>) {
        Task { @MainActor in
            await NotificationService.shared.removeStale(prefix: autoPrefix, keeping: validKeys)
        }
    }


    nonisolated static func schedule(customTask task: CustomTaskModel) {
        let calendar = Calendar.current
        let date = task.alarmDate

        let components: DateComponents
        let repeats: Bool

        switch task.frequency {
        case "Diária":
            components = calendar.dateComponents([.hour, .minute], from: date)
            repeats = true
        case "Semanal":
            components = calendar.dateComponents([.weekday, .hour, .minute], from: date)
            repeats = true
        case "Mensal":
            components = calendar.dateComponents([.day, .hour, .minute], from: date)
            repeats = true
        case "Anual":
            components = calendar.dateComponents([.month, .day, .hour, .minute], from: date)
            repeats = true
        default:
            guard date > Date() else {
                cancel(customTaskID: task.id)
                return
            }
            components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute], from: date
            )
            repeats = false
        }

        let body = task.note.isEmpty
            ? "\(task.vehicleName): está na hora desta manutenção."
            : "\(task.vehicleName): \(task.note)"

        Task { @MainActor in
            await NotificationService.shared.schedule(
                id: "custom.\(task.id.uuidString)",
                title: task.title,
                body: body,
                components: components,
                repeats: repeats
            )
        }
    }

    nonisolated static func cancel(customTaskID id: UUID) {
        Task { @MainActor in
            NotificationService.shared.cancel(ids: ["custom.\(id.uuidString)"])
        }
    }
}


struct MileageRule {
    let key: String
    let title: String
    let interval: Int
    let warnBefore: Int
}

@MainActor
enum MileageAlertService {

    static let rules: [MileageRule] = [
        MileageRule(key: "oil", title: "Troca de óleo", interval: 10_000, warnBefore: 500),
        MileageRule(key: "tires", title: "Alinhamento e balanceamento", interval: 10_000, warnBefore: 500),
        MileageRule(key: "brakes", title: "Revisão das pastilhas de freio", interval: 20_000, warnBefore: 1_000)
    ]

    static func check(car: CarModel) async {
        guard let km = Int(car.kilometers.filter { $0.isNumber }), km > 0 else { return }

        let defaults = UserDefaults.standard
        let carName = car.name.isEmpty ? car.model : car.name
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "pt_BR")

        func formatted(_ value: Int) -> String {
            formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        }

        for rule in rules {
            let reachedKey = "km.\(car.id.uuidString).\(rule.key).reached"
            let warnedKey = "km.\(car.id.uuidString).\(rule.key).warned"

            let passed = (km / rule.interval) * rule.interval
            let next = passed + rule.interval
            if let handled = defaults.object(forKey: reachedKey) as? Int {
                if passed > handled && passed > 0 {
                    await NotificationService.shared.send(
                        id: "km-\(car.id.uuidString)-\(rule.key)-reached-\(passed)",
                        title: "\(rule.title) · \(carName)",
                        body: "Seu carro passou de \(formatted(passed)) km. Está na hora de fazer: \(rule.title.lowercased())."
                    )
                    defaults.set(passed, forKey: reachedKey)
                } else if passed < handled {
                    defaults.set(passed, forKey: reachedKey)
                }
            } else {
                defaults.set(passed, forKey: reachedKey)
            }


            let remaining = next - km
            if remaining <= rule.warnBefore, defaults.integer(forKey: warnedKey) != next {
                await NotificationService.shared.send(
                    id: "km-\(car.id.uuidString)-\(rule.key)-warn-\(next)",
                    title: "\(rule.title) · \(carName)",
                    body: "Faltam cerca de \(formatted(remaining)) km para \(rule.title.lowercased()) (\(formatted(next)) km)."
                )
                defaults.set(next, forKey: warnedKey)
            }
        }
    }
}
#Preview {
    NavigationStack {
        MaintenanceDetailView(
            taskTitle: "Troca de óleo",
            vehicleName: "Meu Carro",
            dueDateText: "Próxima: 10/11/2026",
            taskType: .oilChange
        )
    }
    .environment(CoordinatorCore()) 
}

