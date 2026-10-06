//
//  AddCustomTaskView.swift
//  FluiCar
//
//  Created by Isabella Avelina on 01/10/26.
//

import SwiftUI

struct AddCustomTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    var vehicles: [String]

    var onSave: (CustomTaskModel) -> Void
    var taskToEdit: CustomTaskModel?
    
    @State private var selectedVehicle: String
    @State private var taskTitle: String = ""
    @State private var taskNote: String = ""
    @State private var alarmDate: Date = Date()
    @State private var frequency: String = "Nunca"
    
    private let frequenciesList = ["Nunca", "Diária", "Semanal", "Mensal", "Anual"]
    
    private var availableVehicles: [String] {
        if let name = taskToEdit?.vehicleName, !vehicles.contains(name) {
            return [name] + vehicles
        }
        return vehicles
    }
    
    init(
        vehicles: [String],
        taskToEdit: CustomTaskModel? = nil,
        onSave: @escaping (CustomTaskModel) -> Void
    ) {
        self.vehicles = vehicles
        self.taskToEdit = taskToEdit
        self.onSave = onSave
        
        _selectedVehicle = State(initialValue: taskToEdit?.vehicleName ?? vehicles.first ?? "")
        
        if let task = taskToEdit {
            _taskTitle = State(initialValue: task.title)
            _taskNote = State(initialValue: task.note)
            _alarmDate = State(initialValue: task.alarmDate)
            _frequency = State(initialValue: task.frequency)
        }
    }
    
    var body: some View {
        Form {
            Section {
                Picker("Selecione o Veículo", selection: $selectedVehicle) {
                    ForEach(availableVehicles, id: \.self) { vehicle in
                        Text(vehicle).tag(vehicle)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section(header: Text("Titulo da Tarefa")) {
                TextField("Digite aqui o titulo da tarefa", text: $taskTitle)
            }
            
            Section(header: Text("Anotação")) {
                TextEditor(text: $taskNote)
                    .frame(height: 100)
            }
            
            Section(header: Text("Lembrete")) {
                DatePicker("Alarme", selection: $alarmDate, displayedComponents: [.date, .hourAndMinute])
                
                Picker("Frequencia", selection: $frequency) {
                    ForEach(frequenciesList, id: \.self) { freq in
                        Text(freq).tag(freq)
                    }
                }
            }
        }
        .navigationTitle(taskToEdit != nil ? "Editar Tarefa" : "Nova Tarefa")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            CustomSheetHeader(
                onDismiss: { dismiss() },
                onSave: {
                    let newTask = CustomTaskModel(
                        id: taskToEdit?.id ?? UUID(),
                        vehicleName: selectedVehicle,
                        title: taskTitle.isEmpty ? "Tarefa Sem Título" : taskTitle,
                        note: taskNote,
                        alarmDate: alarmDate,
                        frequency: frequency
                    )
                    onSave(newTask)
                    dismiss()
                },
                isSaveDisabled: taskTitle.isEmpty
            )
        }
    }
}
