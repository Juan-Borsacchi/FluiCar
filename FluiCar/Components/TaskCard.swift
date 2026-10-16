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
                .font(.headline)
                .foregroundStyle(.primary)

            Text("Automóvel: \(vehicle)")
                .font(.footnote)
                .bold()
                .foregroundStyle(.secondary)
            
            HStack(spacing: 6) {
                Circle()
                    .fill(Color("AccentColor"))
                    .frame(width: 8, height: 8)

                Text("Prazo final: \(dueDate)")
                    .environment(\.locale, Locale(identifier: "pt_BR"))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ZStack {
        Color("Background")
            .ignoresSafeArea()

        TaskCard(
            title: "Troca de Óleo",
            vehicle: "Carrinho 1",
            dueDate: "22 de out. de 2026"
        )
        .padding()
    }
}
