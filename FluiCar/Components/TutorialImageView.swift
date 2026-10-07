//
//  TutorialImageView.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 04/10/26.
//

import SwiftUI
import UIKit

struct TutorialImageView: View {
    let image: TutorialImage

    var body: some View {
        Group {
            switch image {
            case .asset(let name, let fallback):
                if UIImage(named: name) != nil {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                } else {
                    systemImageView(fallback)
                }

            case .system(let name):
                systemImageView(name)
            }
        }
    }

    private func systemImageView(_ name: String) -> some View {
        ZStack {
            Color.gray.opacity(0.15)

            Image(systemName: name)
                .resizable()
                .scaledToFit()
                .padding(40)
                .foregroundStyle(.secondary)
        }
    }
}
