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
        VStack(alignment: .leading, spacing: 16) {
            
            ProgressView(value: progress) {
                Text("Etapa \(currentIndex + 1) de \(totalSteps)")
            }
            .animation(.default, value: currentIndex)
            
            Text(step.title)
                .font(.title3)
                .bold()
            
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 180)
                .cornerRadius(12)
                .overlay(Image(systemName: step.imageName).font(.largeTitle).foregroundColor(.gray))
            
            ScrollView {
                Text(step.description)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            
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
        }
        .padding(.top)
        .padding(.horizontal)
    }
}
