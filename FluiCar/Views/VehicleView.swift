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
    @State var deleteAlert = false
    @Environment(CoordinatorCore.self) private var coordinator
    var body: some View {
        ZStack{
            Color(.background)
                .ignoresSafeArea()
            ScrollView {
                
                VStack{
                    
                    
                    if let uiImage = viewModel.carImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 155, idealWidth: 166, maxWidth: 370, minHeight: 155, idealHeight: 166, maxHeight: 166, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                            .clipped()
                        
                        
                    } else {
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.accentColor)
                            .frame(minWidth: 155, idealWidth: 166, maxWidth: 370, minHeight: 155, idealHeight: 166, maxHeight: 166, alignment: .center)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                        
                    }
                    
                    VStack(alignment: .leading){
                        
                        Text("\(viewModel.car.brand) \(viewModel.car.model)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.top, 4)
                        
                        Text("Ano do Modelo: \(viewModel.car.year.description)")
                            .font(.caption)
                            .foregroundStyle(.white)
                        
                        Text("Especificações do Automóvel")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.top, 4)
                        HStack(spacing: 20) {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(Color.accent)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text("Preço na FIPE")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                            Spacer()
                            Text("\(viewModel.car.fipeValue) R$")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                            
                        }
                        .padding()
                        .frame(minWidth: 372, idealWidth: 180, maxWidth: .infinity, minHeight: 51, idealHeight: 102,  maxHeight: .infinity, alignment: .leading)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 17.5))
                        
                        HStack(spacing: 12){
                            InformationsCard(logo: "car.fill", name: "Modelo", information: viewModel.car.model)
                            
                            
                            InformationsCard(logo: "gearshape.circle.fill", name: "Câbio", information: viewModel.transmission.rawValue)
                        }
                        .padding(.top, 4)
                        HStack(spacing: 12){
                            InformationsCard(logo: "drop.circle.fill", name: "Combustível", information: viewModel.car.fuel)
                            InformationsCard(logo: "gauge.open.with.lines.needle.33percent", name: "Quilometragem", information: "\(viewModel.car.kilometers) km")
                        }
                        .padding(.vertical, 4)
                    }
                    
                }
                .padding()
                .frame(minWidth: 350, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity, alignment: .top)
                .metallicBackground()
                .padding(.horizontal, 5)
                VStack(alignment: .leading){
                    Text("Proximas Tarefas")
                        .font(.headline)
                        .fontWeight(.regular)
                        .foregroundStyle(.secondary)
                        .padding(.leading)
                        .padding(.top)
                    if viewModel.car.tasks.isEmpty {
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
                        
                    } else {
                        ForEach(viewModel.car.tasks, id: \.id) { task in
                            ZStack(alignment: .leading) {
                                NavigationLink {
                                    MaintenanceDetailView(
                                        taskTitle: task.title,
                                        vehicleName: viewModel.car.name,
                                        dueDateText: task.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "Sem data"
                                    )
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                TaskCard(
                                    title: task.title,
                                    vehicle: viewModel.car.name,
                                    dueDate: task.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "Sem data"
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
        }
        .toolbar(.hidden, for:.tabBar)
        .onAppear {
            Task {
                await viewModel.fetchInformations()
            }
        }
        .onChange(of: coordinator.sheet) { _, sheet in
            if sheet == nil {
                Task {
                    await viewModel.fetchInformations()
                }
            }
        }
        .navigationTitle(viewModel.car.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    coordinator.popToRoot()
                } label: {
                    Label("Automóveis", systemImage: "chevron.left")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        coordinator.presentSheet(.editVehicle(viewModel.car))
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
        }.alert("Remover Automóvel", isPresented: $deleteAlert) {
            Button("excluir", role: .destructive) {
                Task{
                    await viewModel.delete()
                }
                coordinator.pop()
            }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text("Tem certeza que deseja remover esse automóvel?")
        }
    }
}
#Preview {
    struct PreviewWrapper: View {
        @State private var coordinator = CoordinatorCore()
        
        let mockCar = CarModel(
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
                VehicleView(viewModel: VehicleViewModel(car: mockCar))
                    .environment(coordinator)
                    .sheet(item: $coordinator.sheet) { route in
                        if case .editVehicle(let carToEdit) = route {
                            NavigationStack {
                                AddVehicleView(viewModel: AddVehicleViewModel(car: carToEdit))
                                    .environment(coordinator)
                            }
                        } else {
                            Text("Tela não suportada na Preview")
                        }
                    }
            }
        }
    }
    
    // 2. Retornamos o Wrapper para desenhar a Preview
    return PreviewWrapper()
}
