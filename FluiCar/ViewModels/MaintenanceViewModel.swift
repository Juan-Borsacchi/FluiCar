//
//  MaintenanceViewModel.swift
//  FluiCar
//
//  Created by Isabella Avelina on 29/09/26.
//

import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
class MaintenanceViewModel {
    var tasks: [TaskItemModel] = []
    var customTasks: [CustomTaskModel] = []
    var isLoading = false
    var hasLoaded = false
    var hasCars = false

    struct TaskItemModel: Identifiable {
        let id = UUID()
        let title: String
        let vehicle: String
        let dueDate: String
        let rawDate: Date
        let taskType: TaskType
    }

    // MARK: - Tarefas personalizadas

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

    // MARK: - Filtros

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

    // MARK: - Carregamento

    func loadCarAndTasks() async {
        if !hasLoaded {
            isLoading = true
        }

        do {
            let cars = try await DataService.shared.fetchAll()

            hasCars = !cars.isEmpty
            fetchMaintenanceTasks(for: cars)
        } catch {
            print("Erro ao carregar veículos: \(error)")
            hasCars = false
            fetchMaintenanceTasks(for: [])
        }

        hasLoaded = true
    }

    func fetchMaintenanceTasks(for cars: [CarModel]) {
        guard !cars.isEmpty else {
            tasks = []
            isLoading = false
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

        var generatedTasks: [TaskItemModel] = []

        for car in cars {
            let vehicleName = car.name.isEmpty ? car.model : car.name

            let oilDate = calendar.date(
                byAdding: .month,
                value: 6,
                to: today
            ) ?? today

            let waterDate = calendar.date(
                byAdding: .day,
                value: 15,
                to: today
            ) ?? today

            let brakeDate = calendar.date(
                byAdding: .year,
                value: 1,
                to: today
            ) ?? today

            let batteryDate = calendar.date(
                byAdding: .month,
                value: 8,
                to: today
            ) ?? today

            let tireDate = calendar.date(
                byAdding: .day,
                value: 15,
                to: today
            ) ?? today

            let carTasks: [TaskItemModel] = [
                TaskItemModel(
                    title: "Troca de óleo",
                    vehicle: vehicleName,
                    dueDate: "Próxima: \(formatDate(oilDate))",
                    rawDate: oilDate,
                    taskType: .oilChange
                ),

                TaskItemModel(
                    title: "Verificar a água do radiador",
                    vehicle: vehicleName,
                    dueDate: "Próxima: \(formatDate(waterDate))",
                    rawDate: waterDate,
                    taskType: .waterCheck
                ),

                TaskItemModel(
                    title: "Verificar pastilhas do freio",
                    vehicle: vehicleName,
                    dueDate: "Próxima: \(formatDate(brakeDate))",
                    rawDate: brakeDate,
                    taskType: .brakeCheck
                ),

                TaskItemModel(
                    title: "Testar estado da bateria",
                    vehicle: vehicleName,
                    dueDate: "Próxima: \(formatDate(batteryDate))",
                    rawDate: batteryDate,
                    taskType: .batteryCheck
                ),

                TaskItemModel(
                    title: "Calibrar pneus",
                    vehicle: vehicleName,
                    dueDate: "Próxima: \(formatDate(tireDate))",
                    rawDate: tireDate,
                    taskType: .tireCalibration
                )
            ]

            generatedTasks.append(contentsOf: carTasks)
        }

        tasks = generatedTasks
        isLoading = false
    }
}
