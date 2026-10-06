//
//  AddCustomTaskView.swift
//  FluiCar
//
//  Created by Isabella Avelina on 01/10/26.
//
import SwiftUI

struct AddCustomTaskView: View {
    @Environment(\.dismiss) private var dismiss

    private let vehicles: [CarModel]
    private let taskToEdit: CustomTaskModel?
    private let onSave: (CustomTaskModel) -> Void

    @State private var selectedVehicleID: UUID?
    @State private var title: String
    @State private var note: String
    @State private var alarmDate: Date
    @State private var frequency: ReminderRepeat

    init(
        vehicles: [CarModel],
        taskToEdit: CustomTaskModel? = nil,
        onSave: @escaping (CustomTaskModel) -> Void
    ) {
        self.vehicles = vehicles
        self.taskToEdit = taskToEdit
        self.onSave = onSave

        _selectedVehicleID = State(initialValue: taskToEdit?.vehicleID ?? vehicles.first?.id)
        _title = State(initialValue: taskToEdit?.title ?? "")
        _note = State(initialValue: taskToEdit?.note ?? "")
        _alarmDate = State(initialValue: taskToEdit?.alarmDate ?? Date())
        _frequency = State(initialValue: taskToEdit?.frequency ?? .never)
    }

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        !trimmedTitle.isEmpty && selectedVehicleID != nil
    }

    var body: some View {
        Form {
            Section {
                Picker("Selecione o Veículo", selection: $selectedVehicleID) {
                    ForEach(vehicles) { car in
                        Text(car.name).tag(Optional(car.id))
                    }
                }
                .pickerStyle(.menu)
            }

            Section("Título da Tarefa") {
                TextField("Digite aqui o título da tarefa", text: $title)
            }

            Section("Anotação") {
                TextEditor(text: $note)
                    .frame(height: 100)
            }

            Section("Lembrete") {
                DatePicker("Alarme", selection: $alarmDate, displayedComponents: [.date, .hourAndMinute])

                Picker("Frequência", selection: $frequency) {
                    ForEach(ReminderRepeat.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
            }
        }
        .navigationTitle(taskToEdit == nil ? "Nova Tarefa" : "Editar Tarefa")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            CustomSheetHeader(
                onDismiss: { dismiss() },
                onSave: save,
                isSaveDisabled: !canSave
            )
        }
    }

    private func save() {
        guard let vehicleID = selectedVehicleID else { return }
        onSave(
            CustomTaskModel(
                id: taskToEdit?.id ?? UUID(),
                vehicleID: vehicleID,
                title: trimmedTitle,
                note: note,
                alarmDate: alarmDate,
                frequency: frequency,
                isInsurance: taskToEdit?.isInsurance
            )
        )
        dismiss()
    }
}
