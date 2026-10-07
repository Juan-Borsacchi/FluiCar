//
//  TutorialView.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 01/10/26.
//

import SwiftUI

struct TutorialView: View {
    @State private var viewModel = TutorialViewModel()
    @Environment(CoordinatorCore.self) private var coordinator
    
    let taskType: TaskType
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            tutorialContent
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.tutorial?.title ?? taskType.displayTitle)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if viewModel.currentPhase > 0 {
                        viewModel.goBack()
                    } else {
                        coordinator.pop()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .alert(
            "Atenção: risco de manutenção",
            isPresented: $viewModel.showWarning
        ) {
            Button("Li e entendi", role: .cancel) {
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
            viewModel.prepareTutorial(for: taskType)
        }
        .onChange(of: viewModel.didFinish) { _, didFinish in
            if didFinish {
                coordinator.pop()
            }
        }
    }
    
    @ViewBuilder
    private var tutorialContent: some View {
        if let tutorial = viewModel.tutorial {
            VStack {
                if viewModel.currentPhase == 0 {
                    TutorialIntroView(tutorial: tutorial) {
                        viewModel.handlePrimaryAction()
                    }
                    .transition(.opacity)
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
                    }
                }
            }
            .animation(
                .easeInOut(duration: 0.4),
                value: viewModel.currentPhase
            )
        } else {
            ProgressView("Carregando...")
        }
    }
}

#Preview("Troca de Óleo") {
    NavigationStack {
        TutorialView(taskType: .oilChange)
            .environment(CoordinatorCore())
    }
}

#Preview("Bateria") {
    NavigationStack {
        TutorialView(taskType: .batteryCheck)
            .environment(CoordinatorCore())
    }
}
