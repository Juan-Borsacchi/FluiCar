//
//  TabBars.swift
//  FluiCar
//
//  Created by Isabella Avelina on 29/09/26.
//

import SwiftUI

enum Tabs: Hashable {
    case car
    case maintenance
    case search
}

struct TabBarsView: View {
    @State private var selectedTab: Tabs = .maintenance
    @State private var searchString = ""
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Tab("Carro", systemImage: "car.side.fill", value: .car) {
                Text("Tela do Carro (Em Construção)")
            }
            
            Tab("Tarefas", systemImage: "list.bullet.clipboard.fill", value: .maintenance) {
                NavigationStack {
                    MaintenanceView()
                }
            }
            
            Tab("Buscar", systemImage: "magnifyingglass", value: .search, role: .prominent) {
                NavigationStack {
                    Text("Tela de Busca")
                        .navigationTitle("Buscar")
                        .searchable(text: $searchString)
                }
            }
        }
        .tabViewStyle(.automatic)
    }
}

#Preview {
    TabBarsView()
}
