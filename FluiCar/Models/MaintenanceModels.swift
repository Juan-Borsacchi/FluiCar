//
//  MaintenanceModels.swift
//  FluiCar
//

import Foundation

// MARK: - Filtro

enum TaskFilter: String, CaseIterable, Identifiable {
    case all
    case dueSoon
    case recent

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return "Todas"
        case .dueSoon: return "Prazo para vencer"
        case .recent: return "Manutenção recente"
        }
    }
}

// MARK: - Referência de tarefa (usada na rota de navegação)

enum MaintenanceTaskRef: Hashable {
    case automatic(UUID)
    case custom(UUID)
}

// MARK: - Repetição do lembrete

enum ReminderRepeat: String, CaseIterable, Identifiable, Codable {
    case never = "Nunca"
    case daily = "Diária"
    case weekly = "Semanal"
    case monthly = "Mensal"
    case yearly = "Anual"

    var id: String { rawValue }
    var title: String { rawValue }
    var repeats: Bool { self != .never }

    func triggerComponents(for date: Date, calendar: Calendar = .current) -> DateComponents {
        let units: Set<Calendar.Component>
        switch self {
        case .never: units = [.year, .month, .day, .hour, .minute]
        case .daily: units = [.hour, .minute]
        case .weekly: units = [.weekday, .hour, .minute]
        case .monthly: units = [.day, .hour, .minute]
        case .yearly: units = [.month, .day, .hour, .minute]
        }
        return calendar.dateComponents(units, from: date)
    }
}

// MARK: - Tarefa automática (persistida)

struct AutomaticTask: Identifiable, Codable, Hashable {
    let id: UUID
    let carID: UUID
    let type: TaskType
    var dueDate: Date
    var lastCheckDate: Date?
    var selectedOption: String?
}

// MARK: - Linha da lista (modelo de apresentação)

struct MaintenanceRow: Identifiable, Hashable {
    let ref: MaintenanceTaskRef
    let title: String
    let vehicleName: String
    let dueDate: Date?
    let includesTime: Bool

    var id: MaintenanceTaskRef { ref }

    var isCustom: Bool {
        switch ref {
        case .custom: return true
        case .automatic: return false
        }
    }

    var dueText: String {
        guard let dueDate else { return "Sem prazo definido" }
        return includesTime
            ? dueDate.formatted(date: .abbreviated, time: .shortened)
            : dueDate.formatted(date: .abbreviated, time: .omitted)
    }

    init(task: AutomaticTask, vehicleName: String) {
        self.ref = .automatic(task.id)
        self.title = task.type.maintenanceTitle
        self.vehicleName = vehicleName
        self.dueDate = task.dueDate
        self.includesTime = false
    }

    init(task: CustomTaskModel, vehicleName: String) {
        self.ref = .custom(task.id)
        self.title = task.title
        self.vehicleName = vehicleName
        self.dueDate = task.alarmDate
        self.includesTime = true
    }
}
