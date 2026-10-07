//
//  MaintenanceView.swift
//  FluiCar
//
//  Created by Isabella Avelina on 28/09/26.
//
import SwiftUI

struct MaintenanceView: View {
    @State private var viewModel = MaintenanceViewModel()
    @Environment(CoordinatorCore.self) private var coordinator

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            content
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .task { await viewModel.load() }
        .sheet(isPresented: $viewModel.isShowingAddSheet) {
                    NavigationStack {
                        AddCustomTaskView(vehicles: viewModel.vehicles) { newTask in
                            if let selectedCar = viewModel.vehicles.first(where: { $0.name == newTask.vehicleName }) {
                                viewModel.saveNewTask(newTask, to: selectedCar)
                            } else {
                                if let firstCar = viewModel.vehicles.first {
                                    viewModel.saveNewTask(newTask, to: firstCar)
                                }
                            }
                        }
                    }
                }
        .alert("Aviso", isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }

    // MARK: - Conteúdo

    @ViewBuilder
    private var content: some View {
        switch viewModel.screenState {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed:
            ContentUnavailableView {
                Label("Não foi possível carregar", systemImage: "exclamationmark.triangle.fill")
            } description: {
                Text("Houve um problema ao buscar seus automóveis.")
            } actions: {
                Button("Tentar novamente") {
                    Task { await viewModel.load() }
                }
            }

        case .noCars:
            ContentUnavailableView(
                "Nenhuma manutenção prevista",
                systemImage: "wrench.and.screwdriver.fill",
                description: Text("Cadastre um carro primeiro para ver as manutenções previstas.")
            )

        case .content:
            taskList
        }
    }

    private var taskList: some View {
        List {
            ForEach(viewModel.automaticRows) { row in
                taskRow(row)
            }

            ForEach(viewModel.customRows) { row in
                taskRow(row)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.deleteCustomTask(row)
                        } label: {
                            Label("Excluir", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func taskRow(_ row: MaintenanceRow) -> some View {
        Button {
            coordinator.push(.maintenanceDetail(row.ref))
        } label: {
            TaskCard(
                title: row.title,
                vehicle: row.vehicleName,
                dueDate: row.dueText
            )
        }
        .buttonStyle(.plain)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Text("Próximas Tarefas")
                .font(.title2.weight(.semibold))
                .fixedSize(horizontal: true, vertical: false)
        }
        .sharedBackgroundVisibility(.hidden)

        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                viewModel.isShowingAddSheet = true
            } label: {
                Image(systemName: "plus")
            }
            .disabled(!viewModel.canAddTask)
            .accessibilityLabel("Nova tarefa")

            Menu {
                Picker("Filtrar", selection: $viewModel.selectedFilter) {
                    ForEach(TaskFilter.general) { filter in
                        Text(filter.title).tag(filter)
                    }
                }

                if !viewModel.vehicles.isEmpty {
                    Section("Veículos") {
                        Picker("Veículo", selection: $viewModel.selectedFilter) {
                            ForEach(viewModel.vehicles) { car in
                                Text(car.name).tag(TaskFilter.vehicle(car.id))
                            }
                        }
                    }
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
            }
            .accessibilityLabel("Filtrar tarefas")
        }
    }
}

#Preview {
    NavigationStack {
        MaintenanceView()
            .environment(CoordinatorCore())
    }
}
