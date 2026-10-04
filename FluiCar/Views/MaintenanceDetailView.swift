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
    let taskType: TaskType
}

struct MaintenanceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(CoordinatorCore.self) private var coordinator

    var taskTitle: String
    var vehicleName: String
    var dueDateText: String
    var taskType: TaskType?
    var customTask: CustomTaskModel?
    var onUpdateCustomTask: ((CustomTaskModel) -> Void)?

    @State private var selectedOption: String = "Padrão"
    @State private var lastCheckDate = Date()
    @State private var nextCheckDate: Date =
        Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date()

    @State private var currentCustomTask: CustomTaskModel?
    @State private var showEditSheet = false

    init(
        taskTitle: String,
        vehicleName: String,
        dueDateText: String,
        taskType: TaskType? = nil,
        customTask: CustomTaskModel? = nil,
        onUpdateCustomTask: ((CustomTaskModel) -> Void)? = nil
    ) {
        self.taskTitle = taskTitle
        self.vehicleName = vehicleName
        self.dueDateText = dueDateText
        self.taskType = taskType
        self.customTask = customTask
        self.onUpdateCustomTask = onUpdateCustomTask
        _currentCustomTask = State(initialValue: customTask)
    }

    private var normalizedTaskTitle: String {
        taskTitle.folding(
            options: [.diacriticInsensitive, .caseInsensitive],
            locale: .current
        )
    }

    private var optionsList: [String] {
        let title = normalizedTaskTitle

        if title.contains("oleo") {
            return [
                "Mineral 15W40",
                "Sintético 5W30",
                "Semi-sintético 10W40",
                "Outro"
            ]
        }

        if title.contains("radiador") || title.contains("agua") {
            return [
                "Água Desmineralizada + Aditivo",
                "Apenas Água Desmineralizada"
            ]
        }

        if title.contains("pneu") {
            return [
                "Calibragem Padrão (30 PSI)",
                "Calibragem com Carga (32+ PSI)"
            ]
        }

        if title.contains("bateria") {
            return [
                "Bateria em bom estado",
                "Bateria precisa de teste"
            ]
        }

        if title.contains("freio") {
            return [
                "Desgaste normal",
                "Necessita avaliação"
            ]
        }

        return [
            "Verificação Padrão",
            "Substituição Completa"
        ]
    }

    private var subtitleLabel: String {
        let title = normalizedTaskTitle

        if title.contains("oleo") {
            return "Tipo de óleo"
        }

        if title.contains("radiador") || title.contains("agua") {
            return "Fluido utilizado"
        }

        if title.contains("pneu") {
            return "Tipo de calibragem"
        }

        if title.contains("bateria") {
            return "Estado da bateria"
        }

        if title.contains("freio") {
            return "Estado dos freios"
        }

        return "Especificação"
    }

    private var tutorialsList: [TutorialItem] {
        if let taskType {
            switch taskType {
            case .oilChange:
                return [
                    TutorialItem(
                        title: "Troca completa",
                        duration: TaskType.oilChange.duration,
                        level: TaskType.oilChange.level,
                        taskType: .oilChange
                    ),
                    TutorialItem(
                        title: "Verificação do nível",
                        duration: TaskType.oilCheck.duration,
                        level: TaskType.oilCheck.level,
                        taskType: .oilCheck
                    )
                ]

            case .oilCheck:
                return [
                    TutorialItem(
                        title: "Verificação do nível",
                        duration: TaskType.oilCheck.duration,
                        level: TaskType.oilCheck.level,
                        taskType: .oilCheck
                    ),
                    TutorialItem(
                        title: "Troca completa",
                        duration: TaskType.oilChange.duration,
                        level: TaskType.oilChange.level,
                        taskType: .oilChange
                    )
                ]

            case .waterCheck:
                return [
                    TutorialItem(
                        title: "Verificar a água do radiador",
                        duration: TaskType.waterCheck.duration,
                        level: TaskType.waterCheck.level,
                        taskType: .waterCheck
                    )
                ]

            case .brakeCheck:
                return [
                    TutorialItem(
                        title: "Verificar os freios",
                        duration: TaskType.brakeCheck.duration,
                        level: TaskType.brakeCheck.level,
                        taskType: .brakeCheck
                    )
                ]

            case .tireCalibration:
                return [
                    TutorialItem(
                        title: "Calibragem correta",
                        duration: TaskType.tireCalibration.duration,
                        level: TaskType.tireCalibration.level,
                        taskType: .tireCalibration
                    )
                ]

            case .batteryCheck:
                return [
                    TutorialItem(
                        title: "Verificar a bateria",
                        duration: TaskType.batteryCheck.duration,
                        level: TaskType.batteryCheck.level,
                        taskType: .batteryCheck
                    )
                ]
            }
        }

        return []
    }

    private func completeTask() {
        let calendar = Calendar.current
        let today = Date()
        let title = normalizedTaskTitle

        lastCheckDate = today

        if title.contains("radiador")
            || title.contains("agua")
            || title.contains("pneu")
            || title.contains("calibrar")
            || title.contains("bateria")
            || title.contains("freio") {

            nextCheckDate = calendar.date(
                byAdding: .day,
                value: 15,
                to: today
            ) ?? today

        } else if title.contains("oleo") {
            nextCheckDate = calendar.date(
                byAdding: .month,
                value: 6,
                to: today
            ) ?? today

        } else {
            nextCheckDate = calendar.date(
                byAdding: .month,
                value: 3,
                to: today
            ) ?? today
        }
    }

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    detailsSection

                    if customTask == nil && !tutorialsList.isEmpty {
                        tutorialsSection
                    }

                    finishButton
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
                Button {
                    showEditSheet = true
                } label: {
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
                        subtitleList: subtitleLabel,
                        optionsList: optionsList,
                        selectedOption: $selectedOption,
                        lastCheckDate: $lastCheckDate,
                        nextCheckDate: $nextCheckDate,
                        onSave: {
                            showEditSheet = false
                        },
                        onDismiss: {
                            showEditSheet = false
                        }
                    )
                }
            }
        }
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Detalhes da Tarefa")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)

            VStack(alignment: .leading, spacing: 16) {
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

                        Text(
                            custom.alarmDate.formatted(
                                date: .abbreviated,
                                time: .shortened
                            )
                        )
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
                            .font(.system(size: 16))
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
                            .font(.system(size: 16))
                            .foregroundColor(.primary)

                        Spacer()

                        Text(
                            lastCheckDate.formatted(
                                date: .abbreviated,
                                time: .omitted
                            )
                        )
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                    }

                    Divider()

                    HStack {
                        Text("Próxima checagem")
                            .font(.system(size: 16))
                            .foregroundColor(.primary)

                        Spacer()

                        Text(
                            nextCheckDate.formatted(
                                date: .abbreviated,
                                time: .omitted
                            )
                        )
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
                Text(
                    "• A frequência é uma estimativa. " +
                    "É recomendado verificar conforme a utilização do veículo."
                )
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .padding(.horizontal, 4)
            }
        }
        .padding(20)
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
        .cornerRadius(20)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        }
    }

    private var tutorialsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tutoriais")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)

            Text("Aprenda a realizar a manutenção de forma segura.")
                .font(.system(size: 14))
                .foregroundColor(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(tutorialsList) { tutorial in
                        tutorialCard(for: tutorial)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(20)
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
        .cornerRadius(20)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        }
    }

    @ViewBuilder
    private func tutorialCard(for tutorial: TutorialItem) -> some View {
        Button {
            coordinator.push(.tutorial(tutorial.taskType))
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                TutorialImageView(
                    image: tutorial.taskType.tutorialData.introImage
                )
                .frame(width: 190, height: 100)
                .clipped()

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
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var finishButton: some View {
        Button {
            if customTask == nil {
                completeTask()
            }

            dismiss()
        } label: {
            Text(
                customTask == nil
                ? "Tarefa concluída"
                : "Concluir Visualização"
            )
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .metallicBackground()
            .clipShape(Capsule())
        }
        .padding(.top, 90)
    }
}

struct EditMaintenanceSheet: View {
    var taskTitle: String
    var subtitleList: String
    var optionsList: [String]

    @Binding var selectedOption: String
    @Binding var lastCheckDate: Date
    @Binding var nextCheckDate: Date

    var onSave: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        Form {
            Section(header: Text("Atualizar Informações")) {
                Picker(subtitleList, selection: $selectedOption) {
                    ForEach(optionsList, id: \.self) { option in
                        Text(option)
                            .tag(option)
                    }
                }

                DatePicker(
                    "Última checagem",
                    selection: $lastCheckDate,
                    displayedComponents: .date
                )

                DatePicker(
                    "Próxima checagem",
                    selection: $nextCheckDate,
                    displayedComponents: .date
                )
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
            taskTitle: "Troca de óleo",
            vehicleName: "Honda Civic",
            dueDateText: "Próxima: 10 de outubro",
            taskType: .oilChange
        )
        .environment(CoordinatorCore())
    }
}
