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

    var automaticRows: [MaintenanceRow] {
        filteredAutomaticTasks.compactMap { service.automaticRow(for: $0) }
    }

    var customRows: [MaintenanceRow] {
        service.customTasks
            .sorted { $0.alarmDate < $1.alarmDate }
            .compactMap { service.customRow(for: $0) }
    }

    private var filteredAutomaticTasks: [AutomaticTask] {
        let tasks = service.automaticTasks
        switch selectedFilter {
        case .all:
            return tasks
        case .dueSoon:
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
    }

    func saveNewTask(_ task: CustomTaskModel) {
        service.saveCustomTask(task)
        showAlert("Tarefa '\(task.title)' criada com sucesso!")
    }

    func deleteCustomTask(_ row: MaintenanceRow) {
        guard case .custom(let id) = row.ref else { return }
        service.deleteCustomTask(id: id)
        showAlert("Tarefa '\(row.title)' excluída.")
    }

    private func showAlert(_ message: String) {
        alertMessage = message
        isShowingAlert = true
    }
}
