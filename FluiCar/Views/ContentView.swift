//
//  ContentView.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 18/09/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        AddVehicleView(viewModel: AddVehicleViewModel())
    }
}

#Preview {
    ContentView()
}
