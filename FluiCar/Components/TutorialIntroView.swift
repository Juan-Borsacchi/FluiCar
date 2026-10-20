//
//  TutorialIntroView.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 01/10/26.
//

import SwiftUI

struct TutorialIntroView: View {
    let tutorial: TutorialModel
    let onStart: () -> Void
    
    @State private var contentHeight: CGFloat = 0
    private let maxCardHeight: CGFloat = 220
    
    var body: some View {
        // 1. Removemos o GeometryReader
        VStack(spacing: 0) {
            
            // 2. Colocamos o conteúdo rolável aqui dentro
            ScrollView {
                VStack(alignment: .leading, spacing: 23) {
                    VStack(alignment: .leading, spacing: 12) {
                        TutorialImageView(image: tutorial.introImage)
                            .aspectRatio(16/9, contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 250)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        Text(tutorial.introDescription)
                            .font(.callout)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Materiais necessários")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            
                            // ScrollView interno dos materiais
                            ScrollView(.vertical, showsIndicators: contentHeight > maxCardHeight) {
                                VStack(alignment: .leading, spacing: 16) {
                                    ForEach(tutorial.materials) { material in
                                        Text("**\(material.name):** \(material.description)")
                                            .font(.callout)
                                            .foregroundStyle(.primary)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .onGeometryChange(for: CGFloat.self) { proxy in
                                    proxy.size.height
                                } action: { newHeight in
                                    contentHeight = newHeight
                                }
                            }
                            .scrollBounceBehavior(.basedOnSize)
                            .frame(height: min(contentHeight, maxCardHeight))
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .glassEffect(.regular, in: .rect(cornerRadius: 20))
                        }
                        
                        if let note = tutorial.introNote {
                            Text("• \(note)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
            
            Button(action: onStart) {
                Text("Iniciar Tutorial")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .metallicBackground()
                    .clipShape(Capsule())
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
        .background(Color.background.ignoresSafeArea())
        .toolbar(.hidden, for: .tabBar)
    }
}
