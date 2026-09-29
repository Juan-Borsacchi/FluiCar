//
//  MaintenanceView.swift
//  FluiCar
//
//  Created by Isabella Avelina on 28/09/26.
//
import SwiftUI

struct MaintenanceView: View {
    @State private var selectedFilter = "Todas"
    
    private let filters = ["Todas", "Pendentes", "Concluídas"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text("Próximas Tarefas")
                        .font(.system(size: 24, weight: .semibold))
                        .padding()
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            TaskCard(title: "Trocar o óleo",
                                     vehicle: "Carrinho 1",
                                     dueDate: "Dia 22/10/2026")
                            
                            TaskCard(title: "Verificar a água do radiador",
                                     vehicle: "Carrinho 1",
                                     dueDate: "Dia 22/10/2026")
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        print("Botão de adicionar clicado!")
                    } label: {
                        Image(systemName: "plus")
                    }
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
        }
    }
}

#Preview {
    MaintenanceView()
}
