//
//  AutomobileHomeView.swift
//  FluiCar
//
//  Created by Isabella Avelina on 02/10/26.
//

import SwiftUI

struct AutomobileHomeView: View {
    @State private var viewModel = AutomobileHomeViewModel()
    @State private var showAddVehicle = false
    
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color("Background")
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Seção: Carrossel de Automóveis cadastrados
                        if viewModel.hasLoaded {
                            if viewModel.cars.isEmpty {
                                EmptyVehiclesCardView {
                                    showAddVehicle = true
                                }
                                .padding(.horizontal)
                                .padding(.top, 8)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(viewModel.cars) { car in
                                            AutomobileCardView(
                                                photo: car.photo,
                                                modelName: car.brand,
                                                carName: car.name,
                                                fuelType: car.fuel,
                                                nextTask: viewModel.nextTaskText(for: car)
                                            )
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .padding(.top, 8)
                            }
                        }
                        
                        // Seção: Tutoriais de Manutenção
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Tutoriais de manutenção")
                                .font(.system(size: 24, weight: .semibold))
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    TutorialCardView(
                                        imageName: "passo1_oleo",
                                        title: "Troca de Óleo Rápida",
                                        duration: "5 min",
                                        level: "Iniciante"
                                    )
                                    
                                    TutorialCardView(
                                        imageName: "calibration_image",
                                        title: "Calibragem Correta",
                                        duration: "3 min",
                                        level: "Iniciante"
                                    )
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Automóveis")
                        .font(.system(size: 24, weight: .semibold))
                        .fixedSize(horizontal: true, vertical: false)
                }
                .sharedBackgroundVisibility(.hidden)
                
                // Botão de adicionar à direita
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddVehicle = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(isPresented: $showAddVehicle) {
                ContentView()
            }
        }
        // Recarrega sempre que a tela aparece (inclusive ao voltar do cadastro)
        .onAppear {
            Task { await viewModel.loadCars() }
        }
    }
}

// MARK: - Estado vazio (nenhum veículo cadastrado)
struct EmptyVehiclesCardView: View {
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "car.fill")
                .font(.system(size: 44))
                .foregroundColor(.gray)
            
            Text("Ainda não há veículo cadastrado")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Cadastre seu primeiro automóvel para acompanhar as manutenções e os prazos.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
           
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .metallicBackground()
        .cornerRadius(24)
    }
}

//card de carro
struct AutomobileCardView: View {
    let photo: Data
    let modelName: String
    let carName: String
    let fuelType: String
    let nextTask: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Foto do carro cadastrado (ou um espaço reservado se não houver foto)
            Group {
                if let uiImage = UIImage(data: photo) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    ZStack {
                        Color.gray.opacity(0.3)
                        Image(systemName: "car.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                    }
                }
            }
            .frame(width: 300, height: 180)
            .clipped()
            .cornerRadius(16)
            
            HStack(spacing: 10) {
                HStack {
                    Image(systemName: "car.fill")
                        .foregroundColor(.red)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Modelo: \(modelName)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                        Text(carName)
                            .font(.subheadline)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                
                HStack {
                    Image(systemName: "drop.circle.fill")
                        .foregroundColor(.red)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Combustível")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text(fuelType)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
            
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                Text(nextTask)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .frame(width: 335)
        .metallicBackground()
        .cornerRadius(24)
    }
}
//tutorial
struct TutorialCardView: View {
    let imageName: String
    let title: String
    let duration: String
    let level: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Imagem encostada nas bordas superiores do card
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipped()
            
            // Textos organizados embaixo com o espaçamento interno ideal
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 15))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("\(duration) • \(level)")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .frame(width: 200)
        .glassEffect(.regular .interactive(), in: .rect(cornerRadius: 16))
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    AutomobileHomeView()
}
