//
//  AddCustomTaskView.swift
//  FluiCar
//
//  Created by Isabella Avelina on 01/10/26.

import SwiftUI

struct AddCustomTaskView: View {
    @Environment(\.dismiss) private var dismiss

    private let vehicles: [CarModel]
    private let taskToEdit: CarTaskModel?
    private let onSave: (CarTaskModel) -> Void

    @State private var selectedVehicleID: UUID?
    @State private var title: String
    @State private var note: String
    @State private var alarmDate: Date
    @State private var frequency: ReminderRepeat

    init(
        vehicles: [CarModel],
        taskToEdit: CarTaskModel? = nil,
        onSave: @escaping (CarTaskModel) -> Void
    ) {
        self.vehicles = vehicles
        self.taskToEdit = taskToEdit
        self.onSave = onSave

        let matchingCar = vehicles.first(where: { $0.name == taskToEdit?.vehicleName })
        _selectedVehicleID = State(initialValue: matchingCar?.id ?? vehicles.first?.id)
        
        _title = State(initialValue: taskToEdit?.title ?? "")
        _note = State(initialValue: taskToEdit?.textDescription ?? "")
        _alarmDate = State(initialValue: taskToEdit?.endDate ?? taskToEdit?.startDate ?? Date())
        
        let initialFreq: ReminderRepeat
        if let freqString = taskToEdit?.frequency, let enumValue = ReminderRepeat(rawValue: freqString) {
            initialFreq = enumValue
        } else {
            initialFreq = .never
        }
        _frequency = State(initialValue: initialFreq)
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
                Picker("Selecione o automóvel", selection: $selectedVehicleID) {
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
        guard let vehicleID = selectedVehicleID,
              let selectedVehicle = vehicles.first(where: { $0.id == vehicleID }) else { return }
        
        onSave(
            CarTaskModel(
                id: taskToEdit?.id ?? UUID(),
                title: trimmedTitle,
                textDescription: note,
                startDate: taskToEdit?.startDate ?? Date(),
                endDate: alarmDate,
                frequency: frequency.rawValue,
                vehicleName: selectedVehicle.name, 
                isAutomatic: taskToEdit?.isAutomatic ?? false,
                isInsurance: taskToEdit?.isInsurance
            )
        )
        dismiss()
    }
}
