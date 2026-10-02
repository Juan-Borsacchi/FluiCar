//
//  TutorialViewModel.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 01/10/26.
//

import SwiftUI
import Observation

@Observable
class TutorialViewModel {
    var tutorial: TutorialModel?
    var currentPhase: Int = 1
    var showWarning: Bool = false
    var currentWarningText: String = ""
    
    private let defaultInitialWarning = "A realização de qualquer manutenção é por sua conta e risco. Use equipamentos de segurança e fale com alguém com experiência automotiva."
    
    func loadTutorial(for task: TaskType) {
        self.tutorial = task.tutorialData
    }
    
    func handlePrimaryAction() {
        guard let tutorial = tutorial else { return }
        
        if currentPhase == 0 {
            currentWarningText = defaultInitialWarning
            showWarning = true
        } else {
            let currentStepIndex = currentPhase - 1
            
            let nextStepIndex = currentPhase
            
            if nextStepIndex < tutorial.steps.count {
                if let warning = tutorial.steps[nextStepIndex].warningMessage {
                    currentWarningText = warning
                    showWarning = true
                } else {
                    advancePhase()
                }
            } else {
                finishTutorial()
            }
        }
    }
    
    func confirmWarning() {
        showWarning = false
        advancePhase()
    }
    
    private func advancePhase() {
        guard let tutorial = tutorial else { return }
        if currentPhase < tutorial.steps.count {
            currentPhase += 1
        } else {
            finishTutorial()
        }
    }
    
    func goBack() {
        if currentPhase > 0 {
            currentPhase -= 1
        }
    }
    
    private func finishTutorial() {
        print("Tutorial Finalizado")
    }
}

