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
    @State private var isSplash = false
    var body: some Scene {
        WindowGroup {
            ZStack{
                if isSplash {
                    TabBarsView()
                        .environment(coordinator)
                } else {
                    SplashView(isActive: $isSplash)
                }
                
            }
            .environment(\.locale, Locale(identifier: "pt_BR"))
        }
    }
}
