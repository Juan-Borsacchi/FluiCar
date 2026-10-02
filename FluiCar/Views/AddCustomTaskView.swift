//
//  AddCustomTaskView.swift
//  FluiCar
//
//  Created by Assistente on 01/10/26.
//

import SwiftUI

struct AddCustomTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    // Callbacks para retornar a tarefa criada ou editada
    var onSave: (CustomTaskModel) -> Void
    var taskToEdit: CustomTaskModel?
    
    @State private var selectedVehicle: String = "Meu Carro"
    @State private var taskTitle: String = ""
    @State private var taskNote: String = ""
    @State private var alarmDate: Date = Date()
    @State private var frequency: String = "Nunca"
    
    private let vehiclesList = ["Meu Carro", "Batmóvel", "Outro Veículo"]
    private let frequenciesList = ["Nunca", "Diária", "Semanal", "Mensal", "Anual"]
    
    init(taskToEdit: CustomTaskModel? = nil, onSave: @escaping (CustomTaskModel) -> Void) {
        self.taskToEdit = taskToEdit
        self.onSave = onSave
        
        if let task = taskToEdit {
            _selectedVehicle = State(initialValue: task.vehicleName)
            _taskTitle = State(initialValue: task.title)
            _taskNote = State(initialValue: task.note)
            _alarmDate = State(initialValue: task.alarmDate)
            _frequency = State(initialValue: task.frequency)
        }
    }
    
    var body: some View {
        Form {
            // Secção de Seleção de Veículo
            Section {
                Picker("Selecione o Veículo", selection: $selectedVehicle) {
                    ForEach(vehiclesList, id: \.self) { vehicle in
                        Text(vehicle).tag(vehicle)
                    }
                }
                .pickerStyle(.menu)
            }
            
            // Título da Tarefa
            Section(header: Text("Titulo da Tarefa")) {
                TextField("Digite aqui o titulo da tarefa", text: $taskTitle)
            }
            
            // Anotação / Conteúdo
            Section(header: Text("Anotação")) {
                TextEditor(text: $taskNote)
                    .frame(height: 100)
            }
            
            // Lembrete (Alarme e Frequência)
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
