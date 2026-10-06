//
//  MaintenanceViewModel.swift
//  FluiCar
//
//  Created by Isabella Avelina on 29/09/26.
//

import SwiftUI
import UserNotifications

/// Tarefa automática associada ao nome do carro dono dela.
struct MaintenanceItem: Identifiable {
    let task: CarTaskModel
    let vehicleName: String
    var id: UUID { task.id }
}

@MainActor
@Observable
class MaintenanceViewModel {
    private let dataBase: any VehicleRepositoryProtocol

    var customTasks: [CustomTaskModel] = []
    var cars: [CarModel] = []

    /// Tarefas padrão por carro (guardadas por id para manter os ids das tarefas estáveis).
    private var defaultTasksByCar: [UUID: [CarTaskModel]] = [:]

    var isLoading = false
    var hasLoaded = false

    var hasCars: Bool { !cars.isEmpty }
    var vehicleNames: [String] { cars.map(\.name) }

    var automaticTasks: [MaintenanceItem] {
        cars.flatMap { car in
            (defaultTasksByCar[car.id] ?? []).map {
                MaintenanceItem(task: $0, vehicleName: car.name)
            }
        }
    }

    init(dataBase: (any VehicleRepositoryProtocol)? = nil) {
        self.dataBase = dataBase ?? DataService.shared
    }

    func loadCarAndTasks() async {
        if !hasLoaded { isLoading = true }

        do {
            cars = try await dataBase.fetchAll()
        } catch {
            print("Erro ao carregar veículos: \(error)")
            cars = []
        }

        // Só gera tarefas para carros novos, assim os ids (usados nas notificações) não mudam.
        for car in cars where defaultTasksByCar[car.id] == nil {
            defaultTasksByCar[car.id] = makeDefaultTasks()
        }

        hasLoaded = true
        isLoading = false
    }

    private func makeDefaultTasks() -> [CarTaskModel] {
        let calendar = Calendar.current
        let today = Date()

        return [
            CarTaskModel(
                id: UUID(),
                title: "Troca de Óleo",
                endDate: calendar.date(byAdding: .month, value: 6, to: today)
            ),
            CarTaskModel(
                id: UUID(),
                title: "Água do Radiador",
                endDate: calendar.date(byAdding: .month, value: 3, to: today)
            ),
            CarTaskModel(
                id: UUID(),
                title: "Calibragem de Pneus",
                endDate: calendar.date(byAdding: .day, value: 15, to: today)
            ),
            CarTaskModel(
                id: UUID(),
                title: "Verificação de Freios",
                endDate: calendar.date(byAdding: .month, value: 4, to: today)
            ),
            CarTaskModel(
                id: UUID(),
                title: "Bateria",
                endDate: calendar.date(byAdding: .month, value: 12, to: today)
            )
        ]
    }

    func addCustomTask(_ task: CustomTaskModel) {
        if let index = customTasks.firstIndex(where: { $0.id == task.id }) {
            customTasks[index] = task
        } else {
            customTasks.append(task)
        }
    }

    func deleteCustomTask(at offsets: IndexSet) {
        customTasks.remove(atOffsets: offsets)
    }

    func filteredTasks(for filter: String) -> [MaintenanceItem] {
        switch filter {
        case "Prazo para vencer":
            return automaticTasks.sorted {
                ($0.task.endDate ?? .distantFuture) < ($1.task.endDate ?? .distantFuture)
            }
        case "Manutenção recente":
            return automaticTasks.sorted {
                ($0.task.endDate ?? .distantPast) > ($1.task.endDate ?? .distantPast)
            }
        default:
            return automaticTasks
        }
    }
}

class MaintenanceReminderService {
    static func setDueDate(_ date: Date, key: String, title: String, vehicle: String) {
        let content = UNMutableNotificationContent()
        content.title = "Manutenção: \(title)"
        content.body = "O veículo \(vehicle) precisa de atenção."
        content.sound = .default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: key, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
