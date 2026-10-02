//
//  MaintenanceViewModel.swift
//  FluiCar
//
//  Created by Isabella Avelina on 29/09/26.
//
import Foundation
import SwiftUI

@Observable
class MaintenanceViewModel {
    var tasks: [TaskItemModel] = []
    var customTasks: [CustomTaskModel] = []
    var isLoading: Bool = false
    
    struct TaskItemModel: Identifiable {
        let id = UUID()
        let title: String
        let vehicle: String
        let dueDate: String
        let rawDate: Date
    }
    
    // MARK: - Gestão de Tarefas Personalizadas
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
    
    // MARK: - Função de Filtragem de Tarefas
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
    
    // MARK: - Carregamento de Veículos e Tarefas Automáticas para Todos os Carros
    func loadCarAndTasks() async {
        isLoading = true
        do {
            let cars = try await DataService.shared.fetchAll()
            
            if cars.isEmpty {
                fetchMaintenanceTasks(for: [])
            } else {
                fetchMaintenanceTasks(for: cars)
            }
        } catch {
            print("Erro ao carregar veículos: \(error)")
            fetchMaintenanceTasks(for: [])
        }
    }
    
    func fetchMaintenanceTasks(for cars: [Car]) {
        guard !cars.isEmpty else {
            let distantDate = Date.distantFuture
            self.tasks = [
                TaskItemModel(title: "Troca de óleo", vehicle: "Meu automóvel", dueDate: "Cadastre um automóvel", rawDate: distantDate),
                TaskItemModel(title: "Água do radiador", vehicle: "Meu automóvel", dueDate: "Cadastre um automóvel", rawDate: distantDate),
                TaskItemModel(title: "Pastilhas do freio", vehicle: "Meu automóvel", dueDate: "Cadastre um automóvel", rawDate: distantDate),
                TaskItemModel(title: "Bateria", vehicle: "Meu automóvel", dueDate: "Cadastre um automóvel", rawDate: distantDate),
                TaskItemModel(title: "Pneus", vehicle: "Meu automóvel", dueDate: "Cadastre um automóvel", rawDate: distantDate)
            ]
            self.isLoading = false
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
        
        // Gera o conjunto de tarefas pré-setadas para cada carro cadastrado
        for car in cars {
            let vehicleName = car.name.isEmpty ? car.model : car.name
            
            let oilDate = calendar.date(byAdding: .month, value: 6, to: today) ?? today
            let radiatorDate = calendar.date(byAdding: .day, value: 15, to: today) ?? today
            let brakeDate = calendar.date(byAdding: .year, value: 1, to: today) ?? today
            let batteryDate = calendar.date(byAdding: .month, value: 8, to: today) ?? today
            let tiresDate = calendar.date(byAdding: .day, value: 15, to: today) ?? today
            
            let carTasks = [
                TaskItemModel(title: "Troca de óleo", vehicle: vehicleName, dueDate: "Próxima: \(formatDate(oilDate))", rawDate: oilDate),
                TaskItemModel(title: "Verificar a água do radiador", vehicle: vehicleName, dueDate: "Próxima: \(formatDate(radiatorDate))", rawDate: radiatorDate),
                TaskItemModel(title: "Verificar pastilhas do freio", vehicle: vehicleName, dueDate: "Próxima: \(formatDate(brakeDate))", rawDate: brakeDate),
                TaskItemModel(title: "Testar estado da bateria", vehicle: vehicleName, dueDate: "Próxima: \(formatDate(batteryDate))", rawDate: batteryDate),
                TaskItemModel(title: "Calibrar Pneus", vehicle: vehicleName, dueDate: "Próxima: \(formatDate(tiresDate))", rawDate: tiresDate)
            ]
            
            generatedTasks.append(contentsOf: carTasks)
        }
        
        self.tasks = generatedTasks
        self.isLoading = false
    }
}
