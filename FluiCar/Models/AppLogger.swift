//
//  AppLogger.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 13/10/26.
//

import OSLog
import Foundation

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "FluiCar"

    static let network = Logger(subsystem: subsystem, category: "Rede")
    static let database = Logger(subsystem: subsystem, category: "BaseDados")
    static let interface = Logger(subsystem: subsystem, category: "Interface")
    static let system = Logger(subsystem: subsystem, category: "Sistema")
}
