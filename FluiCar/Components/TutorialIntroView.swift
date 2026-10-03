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
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 23) {
                VStack (alignment: .leading, spacing: 12){
                    Image(tutorial.introImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width - 32, height: geometry.size.height * 0.28)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    
                    Text(tutorial.introDescription)
                        .font(.callout)
                        .foregroundColor(.primary)
                        .minimumScaleFactor(0.8)
                }
                
                VStack (spacing: 10) {
                    VStack (alignment: .leading, spacing: 10) {
                        Text("Materiais necessários")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(tutorial.materials) { material in
                                Text("\(material.name): \(material.description)")
                                    .font(.callout)
                                    .lineLimit(nil)
                                    .foregroundColor(.primary)
                            }
                            
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    if let note = tutorial.introNote {
                        Text("• \(note)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                
                Button(action: onStart) {
                    Text("Iniciar Tutorial")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .metallicBackground()
                        .clipShape(Capsule())
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? 0 : 8)
            }
            .padding(.horizontal)
            .padding(.top)
            .background(Color.background
                .ignoresSafeArea())
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
