//
//  TabBars.swift
//  FluiCar
//
//  Created by Isabella Avelina on 29/09/26.
//

import SwiftUI

enum Tabs: Hashable {
    case carHome
    case maintenance
    case search
}

struct TabBarsView: View {
    @State private var selectedTab: Tabs = .maintenance
    @State private var searchString = ""
    
    @Environment(CoordinatorCore.self) private var coordinator
    
    var body: some View {
        @Bindable var bindableCoordinator = coordinator
        
        TabView(selection: $selectedTab) {
    
            // ABA 1: AUTOMÓVEL
            Tab("Automóvel", systemImage: "car.side.fill", value: .carHome) {
                NavigationStack(path: $bindableCoordinator.carPath) {
                    coordinator.build(.home)
                            .navigationDestination(for: AppRoute.self) { route in
                                coordinator.build(route)
                            }
                }
            }
            
            // ABA 2: TAREFAS (Manutenção)
            Tab("Tarefas", systemImage: "list.bullet.clipboard.fill", value: .maintenance) {
                NavigationStack(path: $bindableCoordinator.maintenancePath) {
                    coordinator.build(.task)
                        .navigationDestination(for: AppRoute.self) { route in
                            coordinator.build(route)
                        }
                }
            }
            
            // ABA 3 BUSCA
            Tab("Buscar", systemImage: "magnifyingglass", value: .search, role: .prominent) {
                NavigationStack(path: $bindableCoordinator.searchPath) {
                    Text("Tela de Busca")
                        .navigationTitle("Buscar")
                        .searchable(text: $searchString)
                        .navigationDestination(for: AppRoute.self) { route in
                            coordinator.build(route)
                        }
                }
            }
        }
        .tabViewStyle(.automatic)
      
        .onChange(of: selectedTab) { oldValue, newValue in
            coordinator.currentTab = newValue
        }
        .onAppear {
            coordinator.currentTab = selectedTab
        }
    }
}

#Preview {
    TabBarsView()
        .environment(CoordinatorCore())
}
