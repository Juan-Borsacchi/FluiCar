//
//  TutorialModel.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 01/10/26.
//

import Foundation

struct TutorialModel {
    let title: String
    let introImageName: String
    let introDescription: String
    let introNote: String?
    let materials: [TutorialMaterial]
    let steps: [TutorialStep]
}

struct TutorialMaterial: Identifiable {
    let id = UUID()
    let name: String
    let description: String
}

struct TutorialStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let warningMessage: String?
}
