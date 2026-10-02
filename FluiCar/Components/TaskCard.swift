//
//  TaskCard.swift
//  FluiCar
//
//  Created by Isabella Avelina on 28/09/26.
//

import SwiftUI

struct TaskCard: View {
    var title: String
    var vehicle: String
    var dueDate: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.primary) // Adapta-se automaticamente (preto no claro, branco no escuro)
                
            Text("Veículo: \(vehicle)")
                .font(.system(size: 13))
                .foregroundColor(.secondary) // Cinzento adaptativo
            
            HStack(spacing: 6) {
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(Color("AccentColor"))
                
                Text("Prazo final: \(dueDate)")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        Color("Primary")
            .ignoresSafeArea()
        
        TaskCard(title: "Trocar o óleo",
                 vehicle: "Carrinho 1",
                 dueDate: "Dia 22/10/2026")
            .padding()
    }
}
