//
//  HapticManager.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 05/10/26.
//

import OSLog

import CoreHaptics
import UIKit

@MainActor
final class HapticManager {
    static let shared = HapticManager()

    private var engine: CHHapticEngine?

    private init() {
        prepareEngine()
    }

    private func prepareEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            Logger.system.error("Não foi possível iniciar o mecanismo háptico: \(error)")
        }
    }

    func warning() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            fallbackWarning()
            return
        }

        do {
            let events = [
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(
                            parameterID: .hapticIntensity,
                            value: 1.0
                        ),
                        CHHapticEventParameter(
                            parameterID: .hapticSharpness,
                            value: 0.9
                        )
                    ],
                    relativeTime: 0
                ),

                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(
                            parameterID: .hapticIntensity,
                            value: 1.0
                        ),
                        CHHapticEventParameter(
                            parameterID: .hapticSharpness,
                            value: 0.9
                        )
                    ],
                    relativeTime: 0.18
                ),

                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(
                            parameterID: .hapticIntensity,
                            value: 1.0
                        ),
                        CHHapticEventParameter(
                            parameterID: .hapticSharpness,
                            value: 0.9
                        )
                    ],
                    relativeTime: 0.36
                )
            ]

            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)

            try engine?.start()
            try player?.start(atTime: CHHapticTimeImmediate)
        } catch {
            Logger.system.error("Erro ao reproduzir haptic de aviso: \(error)")
            fallbackWarning()
        }
    }

    private func fallbackWarning() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
}
