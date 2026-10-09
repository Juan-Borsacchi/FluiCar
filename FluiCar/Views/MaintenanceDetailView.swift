//
//  MaintenanceDetailView.swift
//  FluiCar
//
//  Created by Isabella Avelina on 29/09/26.
//
import SwiftUI

struct MaintenanceDetailView: View {
    @State var viewModel: MaintenanceDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(CoordinatorCore.self) private var coordinator

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            if viewModel.isMissing {
                ContentUnavailableView(
                    "Tarefa não encontrada",
                    systemImage: "questionmark.folder",
                    description: Text("Essa tarefa não existe mais.")
                )
            } else {
                ScrollView {
                    VStack(spacing: 18) {
                        detailsSection

                        if !viewModel.tutorials.isEmpty {
                            tutorialsSection
                        }

                        finishButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Editar") {
                    viewModel.beginEditing()
                }
                .fontWeight(.semibold)
                .disabled(viewModel.isMissing)
            }
        }
        .sheet(isPresented: $viewModel.isShowingEditSheet) {
            NavigationStack {
                editSheet
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .cancel) {
                if viewModel.dismissAfterAlert {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
        .sensoryFeedback(.success, trigger: viewModel.completionCount)
    }

    // MARK: - Edição

    @ViewBuilder
        private var editSheet: some View {
            if let custom = viewModel.customTask {
                AddCustomTaskView(vehicles: viewModel.vehicles, taskToEdit: custom) { updatedTask in
                    
                    if let selectedCar = viewModel.vehicles.first(where: { $0.name == updatedTask.vehicleName }) {
                        viewModel.saveCustomTask(updatedTask, to: selectedCar)
                    } else {
                        if let firstCar = viewModel.vehicles.first {
                            viewModel.saveCustomTask(updatedTask, to: firstCar)
                        }
                    }
                    
                }
            } else {
                EditMaintenanceSheet(viewModel: viewModel)
            }
        }

    // MARK: - Detalhes

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Detalhes da Tarefa")
                .font(.headline)

            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(viewModel.detailRows.enumerated()), id: \.element.id) { index, row in
                    if index > 0 {
                        Divider()
                    }

                    HStack(alignment: .firstTextBaseline) {
                        Text(row.label)

                        Spacer()

                        Text(row.value)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .padding(13)
            .background(Color(.systemGray).opacity(0.2), in: .rect(cornerRadius: 20))

            if let note = viewModel.noteText {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Anotação")
                        .font(.subheadline.weight(.semibold))

                    Text(note)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6), in: .rect(cornerRadius: 16))
            }

            if let footnote = viewModel.footnote {
                Text(footnote)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }
        }
        .detailCardStyle()
    }

    // MARK: - Tutoriais

    private var tutorialsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tutoriais")
                .font(.headline)

            Text("Aprenda a realizar a manutenção de forma segura.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(viewModel.tutorials) { type in
                        tutorialCard(for: type)
                    }
                }
                .padding(.vertical, 4)
            }
            .scrollIndicators(.hidden)
        }
        .detailCardStyle()
    }

    private func tutorialCard(for type: TaskType) -> some View {
        Button {
            coordinator.push(.tutorial(type))
        } label: {
            CardTutorials(type: type)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Botão principal

    private var finishButton: some View {
        Button {
            if viewModel.isCustom {
                dismiss()
            } else {
                viewModel.completeTask()
            }
        } label: {
            Text(viewModel.isCustom ? "Concluir tarefa" : "Tarefa concluída")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .metallicBackground()
                .clipShape(Capsule())
        }
    }
}

// MARK: - Estilo dos cartões

private extension View {
    func detailCardStyle() -> some View {
        self
            .padding(20)
            .glassEffect(.regular, in: .rect(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            }
    }
}

// MARK: - Sheet de edição (tarefa automática)

private struct EditMaintenanceSheet: View {
    @Bindable var viewModel: MaintenanceDetailViewModel

    var body: some View {
        Form {
            Section("Atualizar Informações") {
                Picker(viewModel.optionsTitle, selection: $viewModel.draftOption) {
                    ForEach(viewModel.options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }

                DatePicker(
                    "Última checagem",
                    selection: $viewModel.draftLastCheck,
                    displayedComponents: .date
                )

                DatePicker(
                    "Próxima checagem",
                    selection: $viewModel.draftNextCheck,
                    displayedComponents: .date
                )
            }
        }
        .navigationTitle("Editar \(viewModel.title)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            CustomSheetHeader(
                onDismiss: { viewModel.cancelEditing() },
                onSave: { viewModel.saveEditing() }
            )
        }
    }
}

#Preview {
    NavigationStack {
        MaintenanceDetailView(
            viewModel: MaintenanceDetailViewModel(ref: .automatic(UUID()))
        )
        .environment(CoordinatorCore())
    }
}
