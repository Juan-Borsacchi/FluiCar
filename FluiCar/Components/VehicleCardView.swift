//
//  VehicleCardView.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 06/10/26.
//
import SwiftUI

struct VehicleCardView: View {
    let modelName: String
    let vehicleName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
           

            HStack(spacing: 10) {
                HStack {
//                    Image(systemName: "car.fill")
//                        .foregroundColor(.red)

                    VStack(alignment: .leading, spacing: 2) {
                        

                        Text(vehicleName)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        Text("Modelo: \(modelName)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .cornerRadius(12)

            
            }

            
        }
        .padding(16)
        .frame(width: 335)
        .cornerRadius(24)
    }
}

