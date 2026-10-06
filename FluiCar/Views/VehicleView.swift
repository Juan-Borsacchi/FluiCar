//
//  VehicleView.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 30/09/26.
//

import SwiftUI

@MainActor
struct VehicleView: View {
    @State var viewModel: VehicleViewModel
    @State private var deleteAlert = false
    @State private var showChangeAlert = false
    @Environment(CoordinatorCore.self) private var coordinator
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    vehicleInformationSection
                    upcomingTasksSection
                }
                .padding(.horizontal)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.fetchInformations()
        }
        .onChange(of: coordinator.sheet) { _, sheet in
            // Quando a sheet de edição for fechada,
            // busca novamente os dados persistidos.
            if sheet == nil {
                Task {
                    await viewModel.fetchInformations()
                }
            }
        }
        .navigationTitle(viewModel.car.name)
        .navigationBarTitleDisplayMode(.inline)
  
        .toolbar {
            
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        coordinator.presentSheet(
                            .editVehicle(viewModel.car)
                        )
                    } label: {
                        Label("Editar", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        deleteAlert = true
                    } label: {
                        Label("Excluir", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.primary)
                }
            }
        }
        .alert(
            "Remover Automóvel",
            isPresented: $deleteAlert
        ) {
            Button("Excluir", role: .destructive) {
                Task {
                    await viewModel.delete()
                    coordinator.popToRoot()
                }
            }
            
            Button("Cancelar", role: .cancel) {
                deleteAlert = false
            }
        } message: {
            Text("Tem certeza que deseja remover esse automóvel?")
        }
    }
    
    // MARK: - Informações do veículo
    
    private var vehicleInformationSection: some View {
        VStack(spacing: 0) {
            vehiclePhoto
            
            VStack(alignment: .leading) {
                Text("\(viewModel.car.brand) \(viewModel.car.model)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.top, 12)
                
                Text("Ano do Modelo: \(viewModel.car.year == 32000 ? "Zero KM" : String(viewModel.car.year))")
                    .font(.caption)
                    .foregroundStyle(.white)
                
                Text("Especificações do Automóvel")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.top, 8)
                
                fipeInformationCard
                
                HStack(spacing: 12) {
                    InformationsCard(
                        logo: "car.fill",
                        name: "Modelo",
                        information: viewModel.car.model
                    )
                    
                    InformationsCard(
                        logo: "gearshape.circle.fill",
                        name: "Câmbio",
                        information: viewModel.transmission.rawValue
                    )
                }
                .padding(.top, 4)
                
                HStack(spacing: 12) {
                    InformationsCard(
                        logo: "drop.circle.fill",
                        name: "Combustível",
                        information: viewModel.car.fuel
                    )
                    Button {
                        showChangeAlert = true
                    }label: {
                        ZStack(alignment: .topTrailing){
                            InformationsCard(
                                logo: "gauge.open.with.lines.needle.33percent",
                                name: "Quilometragem",
                                information: "\(viewModel.car.kilometers) km"
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.blue, lineWidth: 1.5)
                            )
                            Group{
                                HStack(spacing: 2){
                                    Text("Ajustar")
                                    Image(systemName: "chevron.right")
                                    
                                }
                                .font(.caption2)
                                .foregroundStyle(Color.blue)
                            }
                            .padding(.trailing)
                            .padding(.top)
                        }
                    }
                    .buttonStyle(.plain)
                    .alert("Quilometragem", isPresented: $showChangeAlert) {
                        TextField("Nova quilometragem", text: $viewModel.car.kilometers)
                            .keyboardType(.numberPad)
                            .onChange(of: viewModel.car.kilometers) { _, newValue in
                                viewModel.car.kilometers = viewModel.textLimit(text: newValue, limit: 7)
                            }
                        
                        Button("Cancelar", role: .cancel) {
                        }
                        
                        Button("Pronto", role: .confirm) {
                            Task {
                                if !viewModel.car.kilometers.isEmpty  {
                                    await viewModel.updateKilometers()
                                }else{
                                    viewModel.car.kilometers = "0"
                                    await viewModel.updateKilometers()
                                }
                                print("Quilometragem atualizada para: \(viewModel.car.kilometers)")
                            }
                        }
//                        .keyboardShortcut(.defaultAction)
//                        Deixa vermelho
                    }message: {
                        Text("Insira o novo valor de quilometragem do seu automóvel.")
                    }
                
                    
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.vertical)
        .padding(.horizontal, 8)
        .metallicBackground()
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
      
        
        
        
    }
    
    // MARK: - Foto do veículo
    
    @ViewBuilder
    private var vehiclePhoto: some View {
        if let uiImage = viewModel.carImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(
                    minWidth: 155,
                    idealWidth: 166,
                    maxWidth: 370,
                    minHeight: 155,
                    idealHeight: 166,
                    maxHeight: 166,
                    alignment: .center
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 32,
                        style: .continuous
                    )
                )
                .clipped()
        } else {
            Image(systemName: "photo")
                .font(.system(size: 40))
                .foregroundStyle(Color.accentColor)
                .frame(
                    minWidth: 155,
                    idealWidth: 166,
                    maxWidth: 370,
                    minHeight: 155,
                    idealHeight: 166,
                    maxHeight: 166,
                    alignment: .center
                )
                .background(Color.gray.opacity(0.3))
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 32,
                        style: .continuous
                    )
                )
        }
    }
    
    // MARK: - Informações da FIPE
    
    private var fipeInformationCard: some View {
        HStack(spacing: 20) {
            Image(systemName: "dollarsign.circle.fill")
                .font(.subheadline)
                .foregroundStyle(Color.accent)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
            
            Text("Preço na FIPE")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.black)
            
            Spacer()
            
            Text("\(viewModel.car.fipeValue)")
                .font(.footnote)
                .foregroundStyle(.gray)
        }
        .padding()
        
        .frame(minWidth: 181, maxWidth: .infinity,minHeight: 50,maxHeight: .infinity ,alignment: .leading)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 17.5)
        )
    }
    
    // MARK: - Próximas tarefas
    
    private var upcomingTasksSection: some View {
        VStack(alignment: .leading) {
            Text("Próximas Tarefas")
                .font(.headline)
                .fontWeight(.regular)
                .foregroundStyle(.secondary)
                .padding(.leading)
                .padding(.top)
            
            if viewModel.car.tasks.isEmpty {
                emptyTasksView
            } else {
                ForEach(viewModel.car.tasks, id: \.id) { task in
                    taskRow(for: task)
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .leading
        )
    }
    
    private var emptyTasksView: some View {
        VStack(spacing: 12) {
            Image(systemName: "checklist")
                .font(.system(size: 40))
                .foregroundStyle(.gray)
            
            Text("Nenhuma tarefa pendente")
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
    
    private func taskRow(for task: CarTaskModel) -> some View {
        let dueDateText = task.endDate?
            .formatted(
                date: .abbreviated,
                time: .omitted
            ) ?? "Sem data"
        
        return ZStack(alignment: .leading) {
            NavigationLink {
                MaintenanceDetailView(
                    taskTitle: task.title,
                    vehicleName: viewModel.car.name,
                    dueDateText: dueDateText
                )
            } label: {
                EmptyView()
            }
            .opacity(0)
            
            TaskCard(
                title: task.title,
                vehicle: viewModel.car.name,
                dueDate: dueDateText
            )
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @State private var coordinator = CoordinatorCore()
        
        private let mockCar = CarModel(
            id: UUID(),
            photo: Data(),
            name: "Carrinho 1",
            brand: "VOLVO",
            model: "XC60 Ultimate",
            year: 2026,
            fuel: "Gasolina",
            kilometers: "12500",
            fipeValue: "100.000",
            insurance: true,
            alarm: Date(),
            frequency: .annual,
            tasks: []
        )
        
        var body: some View {
            NavigationStack {
                VehicleView(
                    viewModel: VehicleViewModel(
                        car: mockCar
                    )
                )
                .environment(coordinator)
                .sheet(item: $coordinator.sheet) { route in
                    NavigationStack {
                        coordinator.build(route)
                            .environment(coordinator)
                    }
                }
            }
        }
    }
    
    return PreviewWrapper()
}
