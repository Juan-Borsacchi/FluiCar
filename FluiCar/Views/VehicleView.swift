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
    @Environment(CoordinatorCore.self) private var coordinator
    private var uiImage: UIImage? = nil
    
    var body: some View {
        ScrollView {
            VStack{
                
                
                if let uiImage = uiImage {
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
                    
                    Text(viewModel.car.name)
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
                        InformationsCard(logo: "car.fill", name: "Modelo", information: viewModel.car.model)
                    }
                    .padding(.top, 4)
                    HStack(spacing: 12){
                        InformationsCard(logo: "car.fill", name: "Modelo", information: viewModel.car.model)
                        InformationsCard(logo: "car.fill", name: "Modelo", information: viewModel.car.model)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .frame(minWidth: 350, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity, alignment: .top)
                .metallicBackground()
            }
        .onAppear {
            Task {
                await viewModel.fetchInformations()
            }
        }
        .navigationTitle(viewModel.car.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                Menu {
                    Button {
                        coordinator.push(.editVehicle(viewModel.car))
                    } label: {
                        Label("Editar", systemImage: "pencil")
                    }
                    Button(role: .destructive){
                        Task{
                            await viewModel.delete()
                        }
                        coordinator.pop()
                    } label: {
                        Label("Excluir", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                    .foregroundStyle(Color.primary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        VehicleView(viewModel: VehicleViewModel(car: CarModel(
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
            tasks: [
                CarTaskModel(
                    id: UUID(),
                    title: "Trocar o óleo",
                    textDescription: "Carro: Carrinho 1",
                    startDate: Date(),
                    endDate: Calendar.current.date(byAdding: .day, value: 22, to: Date()),
                    frequency: "Única"
                )
            ]
        )))
        .environment(CoordinatorCore())
    }
}
