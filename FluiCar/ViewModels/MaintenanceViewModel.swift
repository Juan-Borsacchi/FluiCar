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

    private let service: MaintenanceService

    var selectedFilter: TaskFilter = .all
    var isShowingAddSheet = false
    var isShowingAlert = false
    private(set) var alertMessage = ""

    init(service: MaintenanceService? = nil) {
        self.service = service ?? MaintenanceService.shared
    }

    // MARK: - Estado da tela

    var screenState: ScreenState {
        if !service.hasLoaded { return .loading }
        if service.loadFailed { return .failed }
        if !service.hasCars { return .noCars }
        return .content
    }

    var vehicles: [CarModel] { service.cars }
    var canAddTask: Bool { service.hasCars }

    // MARK: - Linhas da lista

    /// Carro escolhido no filtro (nil quando o filtro não é de veículo).
    private var selectedCarID: UUID? {
        if case .vehicle(let id) = selectedFilter { return id }
        return nil
    }

    var automaticRows: [MaintenanceRow] {
        sortedAutomaticTasks
            .filter { selectedCarID == nil || $0.carID == selectedCarID }
            .compactMap { service.automaticRow(for: $0) }
    }

    var customRows: [MaintenanceRow] {
        service.cars
            .filter { selectedCarID == nil || $0.id == selectedCarID }
            .flatMap { $0.tasks }
            .filter { !$0.isAutomatic }
            .sorted { ($0.endDate ?? Date()) < ($1.endDate ?? Date()) }
            .map { MaintenanceRow(task: $0) }
    }

    private var sortedAutomaticTasks: [AutomaticTask] {
        let tasks = service.automaticTasks
        switch selectedFilter {
        case .all:
            return tasks
        case .dueSoon, .vehicle:
            return tasks.sorted { $0.dueDate < $1.dueDate }
        case .recent:
            return tasks.sorted { lhs, rhs in
                let left = lhs.lastCheckDate ?? .distantPast
                let right = rhs.lastCheckDate ?? .distantPast
                return left == right ? lhs.dueDate < rhs.dueDate : left > right
            }
        }
    }

    // MARK: - Ações

    func load() async {
        await service.load()

        // Se o carro filtrado foi apagado, volta para "Todas".
        if let id = selectedCarID, !service.cars.contains(where: { $0.id == id }) {
            selectedFilter = .all
        }
    }

    func saveNewTask(_ task: CarTaskModel, to car: CarModel) {
            service.saveCustomTask(task, to: car)
            showAlert("Tarefa '\(task.title)' criada com sucesso!")
        }

    func deleteCustomTask(_ row: MaintenanceRow) {
            guard case .custom(let id) = row.ref else { return }
            
            let allTasks = service.cars.flatMap { $0.tasks }
            guard let taskToDelete = allTasks.first(where: { $0.id == id }) else { return }
            
            service.deleteCustomTask(taskToDelete)
            
            showAlert("Tarefa '\(row.title)' excluída.")
        }

    private func showAlert(_ message: String) {
        alertMessage = message
        isShowingAlert = true
    }
}
