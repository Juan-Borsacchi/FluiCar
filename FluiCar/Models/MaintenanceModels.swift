//
//  MaintenanceModels.swift
//  FluiCar
//
//  Created by Isabella Avelina on 01/10/26.
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
    case semiannual = "Semestral"
    case yearly = "Anual"

    var id: String { rawValue }
    var title: String { rawValue }
    // O iOS não repete notificações a cada 6 meses: o semestral é agendado como disparo único
    // e reagendado para a próxima ocorrência sempre que o app sincroniza as tarefas.
    var repeats: Bool { self != .never && self != .semiannual }

    /// Próxima data em que o lembrete deve disparar (só muda para o semestral, que avança de 6 em 6 meses).
    func nextFireDate(from date: Date, after now: Date = Date(), calendar: Calendar = .current) -> Date {
        guard self == .semiannual else { return date }
        var next = date
        while next <= now, let advanced = calendar.date(byAdding: .month, value: 6, to: next) {
            next = advanced
        }
        return next
    }

    func triggerComponents(for date: Date, calendar: Calendar = .current) -> DateComponents {
        let units: Set<Calendar.Component>
        switch self {
        case .never, .semiannual: units = [.year, .month, .day, .hour, .minute]
        case .daily: units = [.hour, .minute]
        case .weekly: units = [.weekday, .hour, .minute]
        case .monthly: units = [.day, .hour, .minute]
        case .yearly: units = [.month, .day, .hour, .minute]
        }
        return calendar.dateComponents(units, from: date)
    }
}

extension FrequencyType {
    /// Frequência do seguro (tela de cadastro do veículo) convertida para a do lembrete.
    var reminderRepeat: ReminderRepeat {
        switch self {
        case .monthly: return .monthly
        case .semiannual: return .semiannual
        case .annual: return .yearly
        case .none: return .never
        }
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

    init(task: CarTaskModel) {
            self.ref = .custom(task.id)
            self.title = task.title
            self.vehicleName = task.vehicleName
            self.dueDate = task.endDate ?? task.startDate
            self.includesTime = true
        }
}
