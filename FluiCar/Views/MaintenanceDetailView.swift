//
//  MaintenanceDetailView.swift
//  FluiCar
//
//  Created by Isabella Avelina on 29/09/26.
//

import SwiftUI

struct TutorialItem: Identifiable {
    let id = UUID()
    let title: String
    let duration: String
    let level: String
}

struct MaintenanceDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    var taskTitle: String
    var vehicleName: String
    var dueDateText: String
    var customTask: CustomTaskModel?
    var onUpdateCustomTask: ((CustomTaskModel) -> Void)?
    
    // Estados principais da visualização
    @State private var selectedOption: String = "Padrão"
    @State private var lastCheckDate: Date = Date()
    @State private var nextCheckDate: Date = Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date()
    
    // Estados específicos se for tarefa personalizada
    @State private var currentCustomTask: CustomTaskModel?
    @State private var showEditSheet = false
    
    init(taskTitle: String, vehicleName: String, dueDateText: String, customTask: CustomTaskModel? = nil, onUpdateCustomTask: ((CustomTaskModel) -> Void)? = nil) {
        self.taskTitle = taskTitle
        self.vehicleName = vehicleName
        self.dueDateText = dueDateText
        self.customTask = customTask
        self.onUpdateCustomTask = onUpdateCustomTask
        _currentCustomTask = State(initialValue: customTask)
    }
    
    private var optionsList: [String] {
        if taskTitle.contains("óleo") {
            return ["Mineral 15W40", "Sintético 5W30", "Semi-sintético 10W40", "Outro"]
        } else if taskTitle.contains("radiador") {
            return ["Água Desmineralizada + Aditivo", "Apenas Água Desmineralizada"]
        } else if taskTitle.contains("pneus") {
            return ["Calibragem Padrão (30 PSI)", "Calibragem com Carga (32+ PSI)"]
        } else {
            return ["Verificação Padrão", "Substituição Completa"]
        }
    }
    
    private var subtitleLabel: String {
        if taskTitle.contains("óleo") {
            return "Tipo de óleo"
        } else if taskTitle.contains("radiador") {
            return "Fluido utilizado"
        } else if taskTitle.contains("pneus") {
            return "Tipo de calibragem"
        } else {
            return "Especificação"
        }
    }
    
    private var tutorialsList: [TutorialItem] {
        if taskTitle.contains("óleo") {
            return [
                TutorialItem(title: "Checagem de nível", duration: "3 min", level: "Iniciante"),
                TutorialItem(title: "Troca completa", duration: "8 min", level: "Intermediário")
            ]
        } else if taskTitle.contains("radiador") {
            return [
                TutorialItem(title: "Como olhar a água", duration: "2 min", level: "Iniciante"),
                TutorialItem(title: "Troca de aditivo", duration: "10 min", level: "Intermediário")
            ]
        } else if taskTitle.contains("pneus") {
            return [
                TutorialItem(title: "Calibragem correta", duration: "3 min", level: "Iniciante")
            ]
        } else {
            return [
                TutorialItem(title: "Checagem geral", duration: "5 min", level: "Iniciante")
            ]
        }
    }
    
    private func completeTask() {
        let calendar = Calendar.current
        let today = Date()
        self.lastCheckDate = today
        
        if taskTitle.contains("radiador") || taskTitle.contains("Pneus") {
            self.nextCheckDate = calendar.date(byAdding: .day, value: 15, to: today) ?? today
        } else if taskTitle.contains("óleo") {
            self.nextCheckDate = calendar.date(byAdding: .month, value: 6, to: today) ?? today
        } else if taskTitle.contains("freio") {
            self.nextCheckDate = calendar.date(byAdding: .year, value: 1, to: today) ?? today
        } else {
            self.nextCheckDate = calendar.date(byAdding: .month, value: 3, to: today) ?? today
        }
    }
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Detalhes da Tarefa")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)

                        
                        VStack (alignment: .leading, spacing: 16) {
                            if let custom = currentCustomTask {
                                HStack {
                                    Text("Veículo")
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(custom.vehicleName)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("Alarme")
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(custom.alarmDate.formatted(date: .abbreviated, time: .shortened))
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("Frequência")
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(custom.frequency)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                }
                            } else {
                                HStack {
                                    Text(subtitleLabel)
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(selectedOption)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("Última checagem")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(lastCheckDate.formatted(date: .abbreviated, time: .omitted))
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("Próxima checagem")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(nextCheckDate.formatted(date: .abbreviated, time: .omitted))
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(13)
                        .background(Color(.systemGray).opacity(0.2))
                        .cornerRadius(20)
                        
                        if let custom = currentCustomTask, !custom.note.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Anotação")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text(custom.note)
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                        } else if customTask == nil {
                            Text("• A frequência é uma estimativa, é recomendado ir verificando conforme a utilização do veículo.")
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 4)
                        }
                    }
                    .padding(20)
                    .glassEffect(.regular, in: .rect(cornerRadius: 16))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    
                    if customTask == nil {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tutoriais")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text("Aprenda a realizar a verificação de forma segura.")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(tutorialsList) { tutorial in
                                        VStack(alignment: .leading, spacing: 0) {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 190, height: 80)
                                            //colocar iumagem dos tutu aqui fofinha
                                                .overlay(
                                                    Image(systemName: "img")
                                                        .font(.system(size: 32))
                                                        .foregroundColor(.white.opacity(0.8))
                                                )
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(tutorial.title)
                                                    .font(.system(size: 16))
                                                    .foregroundColor(.primary)
                                                    .lineLimit(1)
                                                
                                                Text("\(tutorial.duration) • \(tutorial.level)")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding(14)
                                        }
                                        .frame(width: 190)
                                        .glassEffect(.regular, in: .rect(cornerRadius: 16))
                                        .cornerRadius(16)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(20)
                        .glassEffect(.regular, in: .rect(cornerRadius: 16))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                    
                    Button(action: {
                        if customTask == nil {
                            completeTask()
                        }
                        dismiss()
                    }) {
                        Text(customTask == nil ? "Tarefa concluída" : "Concluir Visualização")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .metallicBackground()
                            .clipShape(Capsule())
                    }
                    .padding(.top, 90)
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(taskTitle)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.primary)
                    Spacer()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showEditSheet = true
                }) {
                    Text("Editar")
                        .font(.system(size: 17, weight: .semibold))
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationStack {
                if let custom = currentCustomTask {
                    AddCustomTaskView(taskToEdit: custom) { updatedTask in
                        currentCustomTask = updatedTask
                        onUpdateCustomTask?(updatedTask)
                    }
                } else {
                    EditMaintenanceSheet(
                        taskTitle: taskTitle,
                        subtitleLabel: subtitleLabel,
                        optionsList: optionsList,
                        selectedOption: $selectedOption,
                        lastCheckDate: $lastCheckDate,
                        nextCheckDate: $nextCheckDate,
                        onSave: { showEditSheet = false },
                        onDismiss: { showEditSheet = false }
                    )
                }
            }
        }
    }
}

// Sheet de edição de tarefas padrão
struct EditMaintenanceSheet: View {
    var taskTitle: String
    var subtitleLabel: String
    var optionsList: [String]
    
    @Binding var selectedOption: String
    @Binding var lastCheckDate: Date
    @Binding var nextCheckDate: Date
    
    var onSave: () -> Void
    var onDismiss: () -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Atualizar Informações")) {
                Picker(subtitleLabel, selection: $selectedOption) {
                    ForEach(optionsList, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                
                DatePicker("Última checagem", selection: $lastCheckDate, displayedComponents: .date)
                
                DatePicker("Próxima checagem", selection: $nextCheckDate, displayedComponents: .date)
            }
        }
        .navigationTitle("Editar \(taskTitle)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            CustomSheetHeader(
                onDismiss: onDismiss,
                onSave: onSave,
                isSaveDisabled: false
            )
        }
    }
}
#Preview {
    NavigationStack {
        MaintenanceDetailView(
            taskTitle: "Verificar a água do radiador",
            vehicleName: "Meu Carro",
            dueDateText: "Próxima em breve"
        )
    }
}
