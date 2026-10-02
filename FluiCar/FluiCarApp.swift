//
//  FluiCarApp.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 23/09/26.
//

import SwiftUI
import SwiftData

@main
struct FluiCarApp: App {
    @State private var coordinator = CoordinatorCore()
    
    var body: some Scene {
        WindowGroup {
            TabBarsView()
                .environment(coordinator)
        }
    }
}
