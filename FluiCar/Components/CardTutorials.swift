//
//  CardTutorials.swift
//  FluiCar
//
//  Created by Isabella Avelina on 07/10/26.
//

import SwiftUI

struct CardTutorials: View {
    let type: TaskType
    var width: CGFloat = 190
    var imageHeight: CGFloat = 100

    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                TutorialImageView(image: type.tutorialData.introImage)
                    .frame(width: width, height: imageHeight)
                    .clipped()

                VStack(alignment: .leading, spacing: 4) {
                    Text(type.tutorialShortcutTitle)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .lineLimit(2, reservesSpace: true)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("\(type.duration) • \(type.level)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(14)
            }
            .frame(width: width)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
            .clipShape(.rect(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            }
        }
}

#Preview {
    ZStack {
        Color("Background")
            .ignoresSafeArea()

        HStack(spacing: 16) {
            CardTutorials(type: .oilChange)
        }
        .padding()
    }
}
