//
//  MaintenanceDetailViewModel.swift
//  FluiCar
//
//  Created by Isabella Avelina on 01/10/26.
//

import Foundation
import Observation

struct MaintenanceDetailRow: Identifiable {
    let label: String
    let value: String
    var id: String { label }
}

@MainActor
@Observable
final class MaintenanceDetailViewModel {
    private let service: MaintenanceService
    let ref: MaintenanceTaskRef

    // Rascunho da edição (só vira definitivo ao salvar)
    var draftOption = ""
    var draftLastCheck = Date()
    var draftNextCheck = Date()

    var isShowingEditSheet = false
    var isShowingAlert = false
    private(set) var alertTitle = ""
    private(set) var alertMessage = ""
    private(set) var dismissAfterAlert = false
    private(set) var completionCount = 0

    init(ref: MaintenanceTaskRef, service: MaintenanceService? = nil) {
        self.ref = ref
        self.service = service ?? MaintenanceService.shared
    }

    // MARK: - Dados da tarefa

    private var automaticTask: AutomaticTask? {
        guard case .automatic(let id) = ref else { return nil }
        return service.automaticTask(id: id)
    }

    var customTask: CarTaskModel? {
            guard case .custom(let id) = ref else { return nil }
            return service.cars.flatMap { $0.tasks }.first(where: { $0.id == id })
        }

    var isCustom: Bool {
        if case .custom = ref { return true }
        return false
    }

    var isMissing: Bool { automaticTask == nil && customTask == nil }

    var title: String {
        automaticTask?.type.maintenanceTitle ?? customTask?.title ?? "Tarefa"
    }

    var vehicles: [CarModel] { service.cars }

    private var vehicleName: String {
            if let custom = customTask {
                return custom.vehicleName
            }
            
            if let autoTask = automaticTask,
               let name = service.carName(for: autoTask.carID) {
                return name
            }
            
            return "—"
        }

    // MARK: - Apresentação

    var detailRows: [MaintenanceDetailRow] {
            if let task = automaticTask {
                return [
                    MaintenanceDetailRow(label: "Veículo", value: vehicleName),
                    MaintenanceDetailRow(label: task.type.optionsTitle, value: task.selectedOption ?? task.type.options.first ?? "—"),
                    MaintenanceDetailRow(
                        label: "Última checagem",
                        value: task.lastCheckDate?.formatted(date: .abbreviated, time: .omitted) ?? "Ainda não registrada"
                    ),
                    MaintenanceDetailRow(
                        label: "Próxima checagem",
                        value: task.dueDate.formatted(date: .abbreviated, time: .omitted)
                    )
                ]
            }
            if let task = customTask {
                return [
                    MaintenanceDetailRow(label: "Veículo", value: vehicleName),
                    MaintenanceDetailRow(label: "Alarme", value: (task.endDate ?? Date()).formatted(date: .abbreviated, time: .shortened)),
                    MaintenanceDetailRow(label: "Frequência", value: task.frequency?.capitalized ?? "Nenhuma")
                ]
            }
            return []
        }

    var noteText: String? {
            guard let note = customTask?.textDescription, !note.isEmpty else { return nil }
            return note
        }

    var footnote: String? {
        guard automaticTask != nil else { return nil }
        return "• A frequência é uma estimativa. É recomendado verificar conforme a utilização do veículo."
    }

    var tutorials: [TaskType] {
        automaticTask?.type.relatedTutorials ?? []
    }

    var optionsTitle: String { automaticTask?.type.optionsTitle ?? "" }
    var options: [String] { automaticTask?.type.options ?? [] }

    // MARK: - Edição de tarefa automática

    func beginEditing() {
        if let task = automaticTask {
            draftOption = task.selectedOption ?? task.type.options.first ?? ""
            draftLastCheck = task.lastCheckDate ?? Date()
            draftNextCheck = task.dueDate
        }
        isShowingEditSheet = true
    }

    func cancelEditing() {
        isShowingEditSheet = false
    }

    func saveEditing() {
        guard case .automatic(let id) = ref else { return }
        service.updateAutomaticTask(
            id: id,
            selectedOption: draftOption,
            lastCheckDate: draftLastCheck,
            dueDate: draftNextCheck
        )
        isShowingEditSheet = false
    }

    // MARK: - Edição de tarefa customizada

    func saveCustomTask(_ task: CarTaskModel, to car: CarModel) {
            service.saveCustomTask(task, to: car)
            showAlert(
                title: "Aviso",
                message: "Tarefa '\(task.title)' atualizada com sucesso!",
                dismissAfter: false
            )
        }

    // MARK: - Conclusão

    func completeTask() {
        guard case .automatic(let id) = ref else { return }
        let taskTitle = title
        service.complete(automaticTaskID: id)
        completionCount += 1
        showAlert(
            title: "Tarefa Concluída!",
            message: "A manutenção '\(taskTitle)' foi registrada e a próxima data foi agendada.",
            dismissAfter: true
        )
    }

    private func showAlert(title: String, message: String, dismissAfter: Bool) {
        alertTitle = title
        alertMessage = message
        dismissAfterAlert = dismissAfter
        isShowingAlert = true
    }
}
