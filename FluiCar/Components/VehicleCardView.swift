//
//  VehicleCardView.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 06/10/26.
//
import SwiftUI

struct VehicleCardView: View {
    let brand: String
    let modelName: String
    let vehicleName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(vehicleName)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text("Automóvel: \(brand) \(modelName)")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
        .cornerRadius(16)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        }
    }
}

