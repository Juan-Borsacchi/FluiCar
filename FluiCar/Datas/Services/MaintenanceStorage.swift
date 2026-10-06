//
//  MaintenanceStorage.swift
//  FluiCar
//
//  Created by Isabella Avelina on 01/10/26.
//

import Foundation
import os

protocol MaintenanceStorageProtocol {
    func loadAutomaticTasks() -> [AutomaticTask]
    func saveAutomaticTasks(_ tasks: [AutomaticTask])
    func loadCustomTasks() -> [CustomTaskModel]
    func saveCustomTasks(_ tasks: [CustomTaskModel])
}

final class UserDefaultsMaintenanceStorage: MaintenanceStorageProtocol {
    private enum Key {
        static let automatic = "maintenance.automaticTasks"
        static let custom = "maintenance.customTasks"
    }

    private let defaults: UserDefaults
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "FluiCar",
        category: "MaintenanceStorage"
    )

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadAutomaticTasks() -> [AutomaticTask] { load(key: Key.automatic) }
    func saveAutomaticTasks(_ tasks: [AutomaticTask]) { save(tasks, key: Key.automatic) }
    func loadCustomTasks() -> [CustomTaskModel] { load(key: Key.custom) }
    func saveCustomTasks(_ tasks: [CustomTaskModel]) { save(tasks, key: Key.custom) }

    private func load<T: Decodable>(key: String) -> [T] {
        guard let data = defaults.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            logger.error("Falha ao ler \(key, privacy: .public): \(error.localizedDescription, privacy: .public)")
            return []
        }
    }

    private func save<T: Encodable>(_ items: [T], key: String) {
        do {
            defaults.set(try JSONEncoder().encode(items), forKey: key)
        } catch {
            logger.error("Falha ao salvar \(key, privacy: .public): \(error.localizedDescription, privacy: .public)")
        }
    }
}
