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
                        ForEach(viewModel.filteredTasks(for: selectedFilter)) { task in
                            ZStack(alignment: .leading) {
                                NavigationLink {
                                    MaintenanceDetailView(
                                        taskTitle: task.title,
                                        vehicleName: task.vehicle,
                                        dueDateText: task.dueDate,
                                        taskType: task.taskType,
                                        taskKey: task.key
                                    )
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)

                                TaskCard(
                                    title: task.title,
                                    vehicle: task.vehicle,
                                    dueDate: task.dueDate
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
                                        customTask: customTask,
                                        availableVehicles: viewModel.vehicleNames
                                    ) { updatedTask in
                                        viewModel.addCustomTask(updatedTask)
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
                        .onDelete(perform: viewModel.deleteCustomTask)
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
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MaintenanceView()
    }
}
