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
    
    @State private var showAddCustomTaskSheet = false // Controla a sheet de cadastro do botão +
    
    private let filters = ["Todas", "Prazo para vencer", "Manutenção recente"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    if viewModel.isLoading || !viewModel.hasLoaded {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if !viewModel.hasCars && viewModel.customTasks.isEmpty {
                        // Estado vazio: nenhum carro cadastrado, então não há manutenção prevista
                        ContentUnavailableView(
                            "Nenhuma manutenção prevista",
                            systemImage: "wrench.and.screwdriver.fill",
                            description: Text("Cadastre um carro primeiro para ver as manutenções previstas.")
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            // 1. Tarefas Padrão de Manutenção de Todos os Carros Filtradas
                            ForEach(viewModel.filteredTasks(for: selectedFilter)) { task in
                                ZStack(alignment: .leading) {
                                    NavigationLink {
                                        // Corrigido: Passando taskTitle, vehicleName e dueDateText obrigatoriamente
                                        MaintenanceDetailView(
                                            taskTitle: task.title,
                                            vehicleName: task.vehicle,
                                            dueDateText: task.dueDate
                                        )
                                    } label: {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                    
                                    TaskCard(title: task.title,
                                             vehicle: task.vehicle,
                                             dueDate: task.dueDate)
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            }
                            
                            // 2. Tarefas Personalizadas criadas pelo Utilizador (Com leitura, edição e exclusão)
                            ForEach(viewModel.customTasks) { customTask in
                                ZStack(alignment: .leading) {
                                    NavigationLink {
                                        MaintenanceDetailView(
                                            taskTitle: customTask.title,
                                            vehicleName: customTask.vehicleName,
                                            dueDateText: customTask.alarmDate.formatted(date: .abbreviated, time: .shortened),
                                            customTask: customTask
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
                    // Botão de Adicionar Tarefa Personalizada (Sobe a Sheet de Cadastro)
                    Button {
                        showAddCustomTaskSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(!viewModel.hasCars) // precisa de um carro para criar tarefa
                    
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
            // Recarrega sempre que a tela aparece (ex.: depois de cadastrar um carro na outra aba)
            .onAppear {
                Task { await viewModel.loadCarAndTasks() }
            }
            // Sheet exclusiva para cadastrar nova tarefa através do botão +
            .sheet(isPresented: $showAddCustomTaskSheet) {
                NavigationStack {
                    AddCustomTaskView { newTask in
                        viewModel.addCustomTask(newTask)
                    }
                }
            }
        }
    }
}

#Preview {
    MaintenanceView()
}
