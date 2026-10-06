//
//  MaintenanceView.swift
//  FluiCar
//
//  Created by Isabella Avelina on 28/09/26.
//

import SwiftUI

struct MaintenanceView: View {
    @State private var viewModel = MaintenanceViewModel()
    @State private var selectedFilter = "Todas"
    @State private var showAddCustomTaskSheet = false

    @State private var showAlert = false
    @State private var alertMessage: String?

    private let filters = ["Todas", "Prazo para vencer", "Manutenção recente"]

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack(alignment: .leading) {
                if viewModel.isLoading || !viewModel.hasLoaded {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if !viewModel.hasCars && viewModel.customTasks.isEmpty {
                    ContentUnavailableView(
                        "Nenhuma manutenção prevista",
                        systemImage: "wrench.and.screwdriver.fill",
                        description: Text("Cadastre um carro primeiro para ver as manutenções previstas.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.filteredTasks(for: selectedFilter)) { item in
                            let task = item.task
                            let dataFormatada = task.endDate?.formatted(date: .numeric, time: .omitted) ?? "Sem prazo definido"

                            ZStack(alignment: .leading) {
                                NavigationLink {
                                    MaintenanceDetailView(
                                        taskTitle: task.title,
                                        vehicleName: item.vehicleName,
                                        dueDateText: dataFormatada,
                                        taskKey: task.id.uuidString
                                    )
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)

                                TaskCard(
                                    title: task.title,
                                    vehicle: item.vehicleName,
                                    dueDate: dataFormatada
                                )
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }

                        ForEach(viewModel.customTasks) { customTask in
                            ZStack(alignment: .leading) {
                                NavigationLink {
                                    MaintenanceDetailView(
                                        taskTitle: customTask.title,
                                        vehicleName: customTask.vehicleName,
                                        dueDateText: customTask.alarmDate.formatted(date: .abbreviated, time: .shortened),
                                        vehicles: viewModel.vehicleNames,
                                        customTask: customTask
                                    ) { updatedTask in
                                        viewModel.addCustomTask(updatedTask)
                                        triggerAlert(with: "Tarefa '\(updatedTask.title)' criada com sucesso!")
                                    }
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)

                                TaskCard(
                                    title: customTask.title,
                                    vehicle: customTask.vehicleName,
                                    dueDate: customTask.alarmDate.formatted(date: .abbreviated, time: .shortened)
                                )
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                        .onDelete { indexSet in
                            let tasksToDelete = indexSet.map { viewModel.customTasks[$0] }
                            viewModel.deleteCustomTask(at: indexSet)
                            if let deletedTask = tasksToDelete.first {
                                triggerAlert(with: "Tarefa '\(deletedTask.title)' eliminada.")
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Próximas Tarefas")
                        .font(.system(size: 24, weight: .semibold))
                    Spacer()
                }
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    showAddCustomTaskSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(!viewModel.hasCars)

                Menu {
                    Picker("Filtrar", selection: $selectedFilter) {
                        ForEach(filters, id: \.self) { filter in
                            Text(filter).tag(filter)
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadCarAndTasks()
            }
        }
        .sheet(isPresented: $showAddCustomTaskSheet) {
            NavigationStack {
                AddCustomTaskView(vehicles: viewModel.vehicleNames) { newTask in
                    viewModel.addCustomTask(newTask)
                    triggerAlert(with: "Tarefa '\(newTask.title)' criada com sucesso!")
                }
            }
        }
        .alert("Aviso", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            if let message = alertMessage {
                Text(message)
            }
        }
    }

    private func triggerAlert(with message: String) {
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    NavigationStack {
        MaintenanceView()
    }
}
