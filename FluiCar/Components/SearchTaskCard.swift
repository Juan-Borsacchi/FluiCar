//
//  SearchTaskCard.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 07/10/26.
//
import SwiftUI
struct SearchTaskCard: View {
    
    var title: String
    var vehicle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text("Automóvel: \(vehicle)")
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
