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
    var carPath = NavigationPath()
    var maintenancePath = NavigationPath()
    var searchPath = NavigationPath()
    var sheet: AppRoute? = nil
    var path: NavigationPath {
        get {
            switch currentTab {
            case .carHome: return carPath
            case .maintenance: return maintenancePath
            case .search: return searchPath
            }
        }
        set {
            switch currentTab {
            case .carHome: carPath = newValue
            case .maintenance: maintenancePath = newValue
            case .search: searchPath = newValue
            }
        }
    }
    
    var currentTab: Tabs = .carHome
    
    func push(_ route: AppRoute) {
        switch currentTab {
        case .carHome:
            carPath.append(route)
        case .maintenance:
            maintenancePath.append(route)
        case .search:
            searchPath.append(route)
        }
    }
    
    func pop() {
        switch currentTab {
        case .carHome:
            if !carPath.isEmpty { carPath.removeLast() }
        case .maintenance:
            if !maintenancePath.isEmpty { maintenancePath.removeLast() }
        case .search:
            if !searchPath.isEmpty { searchPath.removeLast() }
        }
    }
    
    func popToRoot() {
        switch currentTab {
        case .carHome:
            carPath = NavigationPath()
        case .maintenance:
            maintenancePath = NavigationPath()
        case .search:
            searchPath = NavigationPath()
        }
    }
    
    func presentSheet(_ route: AppRoute) {
        self.sheet = route
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    @ViewBuilder
    func build(_ route: AppRoute) -> some View {
        switch route {
        case .home:
            AutomobileHomeView()
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
        case .tutorial(let taskType):
            TutorialView(taskType: taskType)
        }
    }
}
