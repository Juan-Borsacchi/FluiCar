//
//  CoordinatorCore.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 23/09/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class CoordinatorCore: CoordinatorProtocol {
    
    
    var path  = NavigationPath()
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(_ route: AppRoute) -> some View {
        switch route {
                case .home:
                    Text("Tela Home")
                case .vehicle(let car):
                        VehicleView(viewModel: VehicleViewModel(car: car))
                case .addVehicle:
                        AddVehicleView(viewModel: AddVehicleViewModel())
                case .editVehicle(let car):
                        AddVehicleView(viewModel: AddVehicleViewModel(car: car))
                case .addTask:
                    Text("Tela Add Task")
                case .editTask:
                    Text("Tela Edit Task")
                case .task:
                    MaintenanceView()
                case .tutorial:
                    Text("Tela Tutorial")
            
        }
    }
    
}
