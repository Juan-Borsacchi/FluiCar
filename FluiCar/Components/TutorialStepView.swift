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

        VStack(spacing: 0) {
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Cabeçalho (Progresso + Título)
                    VStack(alignment: .leading, spacing: 12) {
                        ProgressView(value: progress) {
                            Text("Etapa \(currentIndex + 1) de \(totalSteps)")
                        }
                        .animation(.default, value: currentIndex)
                        
                        HStack(alignment: .firstTextBaseline) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.accentColor)
                                .alignmentGuide(.firstTextBaseline) { context in
                                    context[.firstTextBaseline] - 2
                                }
                            
                            Text(step.title)
                                .font(.title3)
                                .bold()
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    VStack(spacing: 16) {
                        TutorialImageView(image: step.image)
                            .aspectRatio(16/9, contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 250)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        Text(step.description)
                            .font(.body)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(16)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .glassEffect(.regular, in: .rect(cornerRadius: 28))
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 24)
            }
            
            let isLastStep = currentIndex == (totalSteps - 1)
            
            Button(action: onNext) {
                Text(isLastStep ? "Finalizar Tutorial" : "Avançar Etapa")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .metallicBackground()
                    .clipShape(Capsule())
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
        .background(Color("Background").ignoresSafeArea())
        .toolbar(.hidden, for: .tabBar)
    }
}
