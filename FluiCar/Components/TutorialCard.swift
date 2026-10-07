//
//  TutorialCard.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 06/10/26.
//
import SwiftUI

struct TutorialCard: View {
    let id = UUID()
    let title: String
    let duration: String
    let level: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .lineLimit(1)

            Text("\(duration) • \(level)")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding(14)
        .frame(width: 190)
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
        .cornerRadius(16)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        }
       
    }
}
