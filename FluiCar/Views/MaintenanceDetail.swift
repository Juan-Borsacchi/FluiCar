//
//  MaintenanceDetail.swift
//  FluiCar
//
//  Created by Isabella Avelina on 29/09/26.
//

//import SwiftUI
//
//// MARK: - Modelos Locais para o Frontend
//struct MaintenanceDetailModel {
//    let title: String
//    let subtitleWarning: String
//    let oilTypeOptions: [String]
//    let lastCheckDate: String
//    let nextCheckDate: String
//    let tutorials: [TutorialItem]
//}
//
//struct TutorialItem: Identifiable {
//    let id = UUID()
//    let title: String
//    let duration: String
//    let level: String
//}
//
//// MARK: - View
//struct MaintenanceDetail: View {
//    @Environment(\.dismiss) var dismiss
//    
//    // Dados estáticos para visualizares o front perfeitamente
//    @State private var selectedOilType = "Tipos de óleo"
//    private let oilOptions = ["Tipos de óleo", "Mineral 15W40", "Sintético 5W30", "Semi-sintético 10W40"]
//    
//    private let detail = MaintenanceDetailModel(
//        title: "Troca de óleo",
//        subtitleWarning: "A frequência é uma estimativa, é recomendado ir verificando conforme a utilização do veículo.",
//        oilTypeOptions: ["Tipos de óleo", "Mineral 15W40", "Sintético 5W30", "Semi-sintético 10W40"],
//        lastCheckDate: "June 2024",
//        nextCheckDate: "Ago 2024",
//        tutorials: [
//            TutorialItem(title: "Checagem de óleo", duration: "3 min", level: "Iniciante"),
//            TutorialItem(title: "Troca de Óleo", duration: "5 min", level: "Iniciante")
//        ]
//    )
//    
//    var body: some View {
//        ZStack {
//            // Cor de fundo do Assets ("Primary")
//            Color("Primary")
//                .ignoresSafeArea()
//            
//            ScrollView(showsIndicators: false) {
//                VStack(spacing: 20) {
//                    
//                    // MARK: - Bloco Principal da Tarefa
//                    VStack(alignment: .leading, spacing: 14) {
//                        Text("Tarefa")
//                            .font(.system(size: 14, weight: .medium))
//                            .foregroundColor(.gray)
//                        
//                        // Picker do Tipo de Óleo
//                        HStack {
//                            Text("Tipo de óleo")
//                                .font(.system(size: 16, weight: .regular))
//                            Spacer()
//                            Picker("", selection: $selectedOilType) {
//                                ForEach(oilOptions, id: \.self) { option in
//                                    Text(option).tag(option)
//                                }
//                            }
//                            .pickerStyle(.menu)
//                            .accentColor(.black)
//                        }
//                        
//                        Divider()
//                        
//                        // Última Checagem
//                        HStack {
//                            Text("Ultima checagem")
//                                .font(.system(size: 16, weight: .regular))
//                            Spacer()
//                            Text(detail.lastCheckDate)
//                                .font(.system(size: 16, weight: .medium))
//                                .foregroundColor(.secondary)
//                        }
//                        
//                        Divider()
//                        
//                        // Próxima Checagem
//                        HStack {
//                            Text("Próxima checagem")
//                                .font(.system(size: 16, weight: .regular))
//                            Spacer()
//                            Text(detail.nextCheckDate)
//                                .font(.system(size: 16, weight: .medium))
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                    .padding(20)
//                    .background(Color.white)
//                    .cornerRadius(20)
//                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
//                    
//                    // Aviso subtil
//                    Text("• " + detail.subtitleWarning)
//                        .font(.system(size: 13))
//                        .foregroundColor(.gray)
//                        .padding(.horizontal, 4)
//                    
//                    // MARK: - Bloco de Tutoriais
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("Tutoriais")
//                            .font(.system(size: 18, weight: .bold))
//                        
//                        Text("Antes de iniciar a troca de óleo veja o tutorial para ver o nível do óleo.")
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                        
//                        // Carrossel Horizontal de Tutoriais
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 16) {
//                                ForEach(detail.tutorials) { tutorial in
//                                    VStack(alignment: .leading, spacing: 8) {
//                                        // Placeholder para a imagem do tutorial
//                                        Rectangle()
//                                            .fill(Color.gray.opacity(0.2))
//                                            .frame(width: 160, height: 100)
//                                            .cornerRadius(12)
//                                            .overlay(
//                                                Image(systemName: "play.circle.fill")
//                                                    .font(.system(size: 30))
//                                                    .foregroundColor(.black.opacity(0.6))
//                                            )
//                                        
//                                        Text(tutorial.title)
//                                            .font(.system(size: 14, weight: .semibold))
//                                            .lineLimit(1)
//                                        
//                                        Text("\(tutorial.duration) • \(tutorial.level)")
//                                            .font(.system(size: 12))
//                                            .foregroundColor(.gray)
//                                    }
//                                    .frame(width: 160)
//                                }
//                            }
//                        }
//                    }
//                    .padding(20)
//                    .background(Color.white)
//                    .cornerRadius(20)
//                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
//                    
//                    // MARK: - Botão Inferior
//                    Button(action: {
//                        print("Tarefa marcada como concluída")
//                    }) {
//                        Text("Tarefa concluída")
//                            .font(.system(size: 16, weight: .semibold))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.black)
//                            .clipShape(Capsule())
//                    }
//                    .padding(.top, 10)
//                    
//                }
//                .padding(.horizontal, 20)
//                .padding(.top, 10)
//                .padding(.bottom, 30)
//            }
//        }
//        // Cabeçalho idêntico ao do teu Figma (Botão de voltar circular e Botão Editar)
//        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: { dismiss() }) {
//                    Image(systemName: "chevron.left")
//                        .font(.system(size: 16, weight: .semibold))
//                        .foregroundColor(.black)
//                        .frame(width: 40, height: 40)
//                        .background(Color.white)
//                        .clipShape(Circle())
//                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//                }
//            }
//            
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: { print("Editar clicado") }) {
//                    Text("Editar")
//                        .font(.system(size: 14, weight: .semibold))
//                        .foregroundColor(.black)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 8)
//                        .background(Color.white)
//                        .clipShape(Capsule())
//                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    NavigationStack {
//        MaintenanceDetail()
//    }
//}
