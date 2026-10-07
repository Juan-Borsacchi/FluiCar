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
    var currentPhase = 0
    var showWarning = false
    var currentWarningText = ""
    var didFinish = false
    
    private var initialWarningIsVisible = false
    private var initialWarningWasConfirmed = false
    
    private let defaultInitialWarning =
    "A realização de qualquer manutenção é por sua conta e risco.\n\n" +
    "Use equipamentos de segurança e fale com alguém com experiência automotiva."
    
    func prepareTutorial(for task: TaskType) {
        tutorial = task.tutorialData
        currentPhase = 0
        didFinish = false
        
        initialWarningIsVisible = true
        initialWarningWasConfirmed = false
        
        currentWarningText = defaultInitialWarning
        
        Task {
            try? await Task.sleep(for: .seconds(0.4))
            showWarning = true
        }
    }
    
    func handlePrimaryAction() {
        guard let tutorial else { return }
        
        if currentPhase == 0 && !initialWarningWasConfirmed {
            showInitialWarning()
            return
        }
        
        let nextStepIndex = currentPhase
        
        if nextStepIndex < tutorial.steps.count {
            
            if let warning = tutorial.steps[nextStepIndex].warningMessage {
                currentWarningText = warning
                initialWarningIsVisible = false
                showWarning = true
            } else {
                advancePhase()
            }
            
        } else {
            finishTutorial()
        }
    }
    
    func confirmWarning() {
        showWarning = false
        
        if initialWarningIsVisible {
            initialWarningIsVisible = false
            initialWarningWasConfirmed = true
        } else {
            advancePhase()
        }
    }
    
    func goBack() {
        guard currentPhase > 0 else {
            return
        }
        
        currentPhase -= 1
    }
    
    private func showInitialWarning() {
        currentWarningText = defaultInitialWarning
        initialWarningIsVisible = true
        showWarning = true
    }
    
    private func advancePhase() {
        guard let tutorial else {
            return
        }
        
        if currentPhase < tutorial.steps.count {
            currentPhase += 1
        } else {
            finishTutorial()
        }
    }
    
    private func finishTutorial() {
        didFinish = true
    }
}
