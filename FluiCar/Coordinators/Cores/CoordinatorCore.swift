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
}
