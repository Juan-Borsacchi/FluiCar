//
//  ViewFramePreference.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 09/10/26.
//

import SwiftUI

struct ViewFramePreferenceKey: PreferenceKey {
    typealias Value = [String: CGRect]
    static var defaultValue: [String: CGRect] = [:]

    static func reduce(value: inout [String: CGRect], nextValue: () -> [String: CGRect]) {
        let next = nextValue()
        for (key, rect) in next {
            if let existing = value[key] {
                value[key] = existing.union(rect)
            } else {
                value[key] = rect
            }
        }
    }
}

extension View {
    func readFrame(id: String) -> some View {
        self.background(
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ViewFramePreferenceKey.self,
                    value: [id: geometry.frame(in: .global)]
                )
            }
        )
    }
}
