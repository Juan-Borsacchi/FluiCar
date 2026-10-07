//
//  MetallicCardModifier.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 29/09/26.
//

import SwiftUI

struct MetallicCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    LinearGradient(
                        stops: [
                            .init(color: Color("Metalico_141417"), location: 0.0),
                            .init(color: Color("Metalico_1F1F21"), location: 0.45),
                            .init(color: Color("Metalico_1A1A1C"), location: 0.55),
                            .init(color: Color("Metalico_0F0F12"), location: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    AngularGradient(
                        stops: [
                            .init(color: Color.white.opacity(0.10), location: 0.0),
                            .init(color: Color.white.opacity(0.18), location: 0.12),
                            .init(color: Color.white.opacity(0.05), location: 0.22),
                            .init(color: Color.white.opacity(0.12), location: 0.38),
                            .init(color: Color.white.opacity(0.05), location: 0.52),
                            .init(color: Color.white.opacity(0.15), location: 0.65),
                            .init(color: Color.white.opacity(0.05), location: 0.78),
                            .init(color: Color.white.opacity(0.10), location: 0.90),
                            .init(color: Color.white.opacity(0.08), location: 1.0)
                        ],
                        center: UnitPoint(x: 0.00, y: 0.34)
                    )
                    .opacity(0.58)
                    .blendMode(.plusLighter)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension View {
    func metallicBackground(cornerRadius: CGFloat = 16) -> some View {
        self.modifier(MetallicCardModifier(cornerRadius: cornerRadius))
    }
}
