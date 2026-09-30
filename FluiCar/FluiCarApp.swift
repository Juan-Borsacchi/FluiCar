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
            /*NavigationStack(path: $coordinator.path) {
                ContentView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        }
                    }
            }*/
        }
    }
}
