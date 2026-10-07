//
//  TutorialStepView.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 01/10/26.
//


import SwiftUI

struct TutorialStepView: View {
    let step: TutorialStep
    let totalSteps: Int
    let currentIndex: Int
    let onNext: () -> Void
    private var progress: Double {
        guard totalSteps > 0 else { return 0.0 }
        return Double(currentIndex + 1) / Double(totalSteps)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                VStack (alignment: .leading){
                    ProgressView(value: progress) {
                        Text("Etapa \(currentIndex + 1) de \(totalSteps)")
                    }
                    .animation(.default, value: currentIndex)
                    
                    HStack (alignment: .firstTextBaseline) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.accentColor)
                            .alignmentGuide(.firstTextBaseline) { context in
                                context[.firstTextBaseline] - (context.height * -0.2)
                            }
                        
                        Text(step.title)
                            .font(.title3)
                            .bold()
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)
                
                VStack (spacing: 10) {
                    TutorialImageView(image: step.image)
                        .frame(
                            width: geometry.size.width - 32,
                            height: geometry.size.height * 0.28
                        )
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    ScrollView {
                        Text(step.description)
                            .font(.body)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(8)
                .padding(.bottom)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .glassEffect(.regular .interactive(),  in: .rect(cornerRadius: 28))
                
                Spacer()
                
                let isLastStep = currentIndex == (totalSteps - 1)
                
                Button(action: onNext) {
                    Text(isLastStep ? "Finalizar Tutorial" : "Avançar Etapa")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .metallicBackground()
                        .clipShape(.capsule)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? 0 : 8)
            }
            .padding(.top)
            .padding(.horizontal, 8)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
