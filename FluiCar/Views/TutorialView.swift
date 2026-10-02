//
//  TutorialView.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 01/10/26.
//

import SwiftUI

struct TutorialView: View {
    @State private var viewModel = TutorialViewModel()
    
    
    @Environment(\.dismiss) var dismiss
    let taskType: TaskType
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            if let tutorial = viewModel.tutorial {
                VStack {
                    if viewModel.currentPhase == 0 {
                        TutorialIntroView(tutorial: tutorial) {
                            viewModel.handlePrimaryAction()
                        }
                        .transition(.opacity)//(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    } else {
                        let stepIndex = viewModel.currentPhase - 1
                        if stepIndex < tutorial.steps.count {
                            TutorialStepView(
                                step: tutorial.steps[stepIndex],
                                totalSteps: tutorial.steps.count,
                                currentIndex: stepIndex
                            ) {
                                viewModel.handlePrimaryAction()
                            }
                            //.id(stepIndex)
                            //.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.4), value: viewModel.currentPhase)
                
                .alert("AVISO", isPresented: $viewModel.showWarning) {
                    Button("Confirmar", role: .cancel) {
                        viewModel.confirmWarning()
                    }
                } message: {
                    Text(viewModel.currentWarningText)
                }
                
            } else {
                ProgressView("Carregando...")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.tutorial?.title ?? "")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if viewModel.currentPhase > 0 {
                        viewModel.goBack()
                    } else {
                        dismiss()
                    }
                }) {
                    Image(systemName: "chevron.left")

                }
            }
        }
        .onAppear {
            viewModel.loadTutorial(for: taskType)
        }
    }
}

#Preview("Ver e Trocar Água") {
    NavigationStack {
        TutorialView(taskType: .verificarAgua)
    }
}

#Preview("Troca de Óleo") {
    NavigationStack {
        TutorialView(taskType: .trocaOleo)
    }
}
