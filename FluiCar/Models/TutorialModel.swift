//
//  TutorialModel.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 01/10/26.
//

import Foundation

enum TutorialImage: Hashable {
    case asset(name: String, fallback: String)
    case system(String)
}

struct TutorialModel {
    let title: String
    let introImage: TutorialImage
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
    let image: TutorialImage
    let warningMessage: String?
    let warningTitle: String?

}
