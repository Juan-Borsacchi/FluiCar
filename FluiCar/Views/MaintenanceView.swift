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
    
    @AppStorage("hasSeenMaintenanceScreenHint") private var hasSeenHint: Bool = false
    
    @State private var autoTaskFrame: CGRect = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                    .toolbar((!hasSeenHint && autoTaskFrame != .zero) ? .hidden : .visible, for: .tabBar)
                
                content
                
                if !hasSeenHint && autoTaskFrame != .zero {
                    AutomaticTasksHintOverlay(
                        automaticTaskFrame: autoTaskFrame
                    ) {
                        hasSeenHint = true
                    }
                    .zIndex(100)
                    .transition(.opacity)
                }
            }
            .onPreferenceChange(ViewFramePreferenceKey.self) { frames in
                DispatchQueue.main.async {
                    if let taskFrame = frames["autoTaskCard"] {
                        self.autoTaskFrame = taskFrame
                    }
                }
            }
            .alert(
                viewModel.pendingAction?.title ?? "Confirmar",
                isPresented: $viewModel.isShowingConfirmation,
                presenting: viewModel.pendingAction
            ) { action in
                Button(action.confirmLabel, role: action.isDelete ? .destructive : nil) {
                    viewModel.confirmPendingAction()
                }
                Button("Cancelar", role: .cancel) {
                    viewModel.cancelPendingAction()
                }
            } message: { action in
                Text(action.message)
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
            .alert(viewModel.alertTitle, isPresented: $viewModel.isShowingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
    
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
            VStack(spacing: 0) {
                statusPicker
                taskList
            }
        }
    }
    
    private var statusPicker: some View {
        Picker("Status", selection: $viewModel.selectedStatus) {
            ForEach(MaintenanceStatusFilter.allCases) { status in
                Text(status.title).tag(status)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private var taskList: some View {
        List {
            ForEach(viewModel.automaticRows) { row in
                taskRow(row)
            }
            
            ForEach(viewModel.customRows) { row in
                taskRow(row)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .overlay {
            if !viewModel.hasVisibleRows {
                ContentUnavailableView(
                    viewModel.selectedStatus.emptyTitle,
                    systemImage: "wrench.and.screwdriver.fill"
                )
            }
        }
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
            .background(
                Group {
                    if !row.isCustom {
                        Color.clear.readFrame(id: "autoTaskCard")
                    }
                }
            )
        }
        .buttonStyle(.plain)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            completeButton(for: row)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            if row.isCustom {
                deleteButton(for: row)
            }
        }
        .contextMenu {
            completeButton(for: row)
            
            if row.isCustom {
                deleteButton(for: row)
            }
        }
    }
    
    private func completeButton(for row: MaintenanceRow) -> some View {
        Button {
            viewModel.requestComplete(row)
        } label: {
            Label("Concluir", systemImage: "checkmark.circle.fill")
        }
        .tint(.green)
    }
    
    private func deleteButton(for row: MaintenanceRow) -> some View {
        Button(role: .destructive) {
            viewModel.requestDelete(row)
        } label: {
            Label("Excluir", systemImage: "trash")
        }
    }
    
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
                    Text("Todos").tag(TaskFilter.all)
                }
                
                if !viewModel.vehicles.isEmpty {
                    Menu {
                        Picker("Automóvel", selection: $viewModel.selectedFilter) {
                            ForEach(viewModel.vehicles) { car in
                                Text(car.name).tag(TaskFilter.vehicle(car.id))
                            }
                        }
                    } label: {
                        Label("Automóveis", systemImage: "car")
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
