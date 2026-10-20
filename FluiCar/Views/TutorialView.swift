//
//  TutorialView.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 01/10/26.
//

import SwiftUI

enum TutorialPhase: Hashable {
    case intro
    case step(Int)
}

struct TutorialView: View {
    @State private var viewModel = TutorialViewModel()
    @Environment(CoordinatorCore.self) private var coordinator
    
    let taskType: TaskType
    let phase: TutorialPhase
    
    var body: some View {
        ZStack {
                Color("Background")
                    .ignoresSafeArea()
                tutorialContent
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.tutorial?.title ?? taskType.displayTitle)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .alert(
            "\(viewModel.warningTitle)",
            isPresented: $viewModel.showWarning
        ) {
            Button("Li e Estou de Acordo", role: .cancel) {
                viewModel.confirmWarning()
            }
        } message: {
            Text(viewModel.currentWarningText)
        }
        .onChange(of: viewModel.showWarning) { _, isPresented in
            guard isPresented else { return }
            
            HapticManager.shared.warning()
        }
        .task {
            _ = HapticManager.shared
            viewModel.prepareTutorial(for: taskType, phase: phase)
        }
    }
    
    @ViewBuilder
    private var tutorialContent: some View {
        if let tutorial = viewModel.tutorial {
            switch phase {
            case .intro:
                TutorialIntroView(tutorial: tutorial) {
                    coordinator.push(.tutorialStep(taskType, 0))
                }
                
            case .step(let stepIndex):
                if tutorial.steps.indices.contains(stepIndex) {
                    TutorialStepView(
                        step: tutorial.steps[stepIndex],
                        totalSteps: tutorial.steps.count,
                        currentIndex: stepIndex
                    ) {
                        advance(
                            from: stepIndex,
                            totalSteps: tutorial.steps.count
                        )
                    }
                } else {
                    ContentUnavailableView(
                        "Etapa inválida",
                        systemImage: "exclamationmark.triangle"
                    )
                }
            }
        } else {
            ProgressView("Carregando...")
        }
    }
    
    private func advance(
        from stepIndex: Int,
        totalSteps: Int
    ) {
        let nextIndex = stepIndex + 1
        
        if nextIndex < totalSteps {
            coordinator.push(
                .tutorialStep(taskType, nextIndex)
            )
        } else {
            finishTutorial(from: stepIndex)
        }
    }
    
    private func finishTutorial(from stepIndex: Int) {
        coordinator.pop(count: stepIndex + 2)
    }
}

#Preview("Troca de Óleo") {
    NavigationStack {
        TutorialView(
            taskType: .oilChange,
            phase: .intro
        )
        .environment(CoordinatorCore())
    }
}

#Preview("Bateria") {
    NavigationStack {
        TutorialView(
            taskType: .batteryCheck,
            phase: .intro
        )
        .environment(CoordinatorCore())
    }
}
