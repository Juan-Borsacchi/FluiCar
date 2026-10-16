//
//  TutorialViewModel.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 01/10/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class TutorialViewModel {
    var tutorial: TutorialModel?
    var showWarning = false
    var warningTitle = ""
    var currentWarningText = ""
    
    @ObservationIgnored
    private var pendingAction: (() -> Void)?
    
    private var hasShownEntryWarning = false
    
    private let defaultTitleWarning = "Atenção: Risco de Manutenção"
    
    private let defaultInitialWarning =
    "A realização de qualquer manutenção é por sua conta e risco.\n\n" +
    "Use equipamentos de segurança e fale com alguém com experiência automotiva."
    
    func prepareTutorial(for task: TaskType, phase: TutorialPhase) {
        if tutorial == nil {
            tutorial = task.tutorialData
        }
        
        guard !hasShownEntryWarning, let tutorial else { return }
        hasShownEntryWarning = true
        
        switch phase {
        case .intro:
            warningTitle = defaultTitleWarning
            currentWarningText = defaultInitialWarning
            presentWarningAfterTransition()
            
        case .step(let stepIndex):
            if tutorial.steps.indices.contains(stepIndex),
               let stepWarning = tutorial.steps[stepIndex].warningMessage {
                warningTitle = tutorial.steps[stepIndex].warningTitle ?? defaultTitleWarning
                currentWarningText = stepWarning
                presentWarningAfterTransition()
            }
        }
    }
    
    private func presentWarningAfterTransition() {
        Task {
            try? await Task.sleep(for: .seconds(0.2))
            showWarning = true
        }
    }
    
    func confirmWarning() {
        showWarning = false
        let action = pendingAction
        pendingAction = nil
        action?()
    }
}
