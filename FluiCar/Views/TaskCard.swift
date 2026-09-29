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
                
            Text("Veículo: \(vehicle)")
                .font(.system(size: 13))
                .foregroundColor(.gray)
            
            HStack(spacing: 6) {
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(Color("AccentColor"))
                
                Text("Prazo final: \(dueDate)")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white) // O fundo do cartão é branco
        .cornerRadius(16)
    }
}

#Preview {
    // O ZStack fica apenas no preview para ver o contraste do cartão com o fundo
    ZStack {
        // A cor de fundo para o teu teste
        Color(UIColor.systemGray6)
            .ignoresSafeArea()
        
        TaskCard(title: "Trocar o óleo",
                 vehicle: "Carrinho 1",
                 dueDate: "Dia 22/10/2026")
            .padding()
    }
}
