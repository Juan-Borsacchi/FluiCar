//
//  AutomobileHomeView.swift
//  FluiCar
//
//  Created by Isabella Avelina on 02/10/26.
//

import SwiftUI

struct AutomobileHomeView: View {
    @State private var showAddVehicle = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color("Background")
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Seção: Carrossel de Automóveis
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                AutomobileCardView(
                                    imageName: "volvo_car",
                                    modelName: "Volvo",
                                    carName: "Carrinho1",
                                    fuelType: "Gasolina",
                                    nextTask: "Próxima tarefa: Trocar o óleo"
                                )
                                
                                AutomobileCardView(
                                    imageName: "volvo_car",
                                    modelName: "Jeep",
                                    carName: "Renegade",
                                    fuelType: "Diesel",
                                    nextTask: "Próxima tarefa: Revisão geral"
                                )
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 8)
                        
                        // Seção: Tutoriais de Manutenção
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Tutoriais de manutenção")
                                .font(.title2)
                                .fontWeight(.bold)
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
                        
                        // Espaço inferior para não cobrir o conteúdo com a TabBar flutuante
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Título alinhado à esquerda idêntico ao MaintenanceView
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Automóveis")
                            .font(.system(size: 24, weight: .semibold))
                        Spacer()
                    }
                }
                
                // Botão de adicionar à direita
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddVehicle = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color(.systemBackground))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                }
            }
//            .navigationDestination(isPresented: $showAddVehicle) {
//                ContentView()[cite: 19]
//            }
        }
    }
}

// MARK: - Componente do Cartão de Automóvel
struct AutomobileCardView: View {
    let imageName: String
    let modelName: String
    let carName: String
    let fuelType: String
    let nextTask: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
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
                        Text(carName)
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                
                HStack {
                    Image(systemName: "fuelpump.fill")
                        .foregroundColor(.red)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Combustível")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text(fuelType)
                            .font(.subheadline)
                            .fontWeight(.bold)
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
            }
            .padding(.top, 4)
        }
        .padding(16)
        .frame(width: 335)
        .background(Color(.sRGB, red: 0.11, green: 0.11, blue: 0.12))
        .cornerRadius(24)
    }
}

// MARK: - Componente do Cartão de Tutorial
struct TutorialCardView: View {
    let imageName: String
    let title: String
    let duration: String
    let level: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 160)
                .clipped()
                .cornerRadius(16)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text("\(duration) • \(level)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 160)
    }
}

#Preview {
    AutomobileHomeView()
}
