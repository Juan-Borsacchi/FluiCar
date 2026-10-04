//
//  CoordinatorRoutes.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 21/09/26.
//

enum AppRoute: Hashable, Identifiable {
    case home
    case vehicle(CarModel)
    case addVehicle
    case editVehicle(CarModel)
    case addTask
    case editTask(CarTaskModel)
    case task
    case tutorial(TaskType)

    var id: String {
        String(describing: self)
    }
}
