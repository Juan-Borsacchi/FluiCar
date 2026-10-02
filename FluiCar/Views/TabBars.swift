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
    
    @Environment(CoordinatorCore.self) private var coordinator
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Tab("Automóvel", systemImage: "car.side.fill", value: .car) {
                Text("Tela do Carro (Em Construção)")
            }
            
            Tab("Tarefas", systemImage: "list.bullet.clipboard.fill", value: .maintenance) {
                @Bindable var bindableCoordinator = coordinator
                NavigationStack(path: $bindableCoordinator.path) {
                    coordinator.build(.task)
                    
                        .navigationDestination(for: AppRoute.self) {route in
                            coordinator.build(route)
                        }
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
        .environment(CoordinatorCore())
}
