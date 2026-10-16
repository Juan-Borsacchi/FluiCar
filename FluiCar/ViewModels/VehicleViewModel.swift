//
//  VehicleViewModel.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 30/09/26.
//

import SwiftUI
import Observation
import OSLog

@MainActor
@Observable
class VehicleViewModel {

    private let service: any VehicleServiceProtocol
    private let dataBase: any VehicleRepositoryProtocol
    private let maintenance: MaintenanceService

    var car: CarModel
    var carImage: UIImage? = nil

    var transmission: TransmissionType {
        return getTransmission(from: car.model)
    }

    var upcomingTasks: [MaintenanceRow] {
        maintenance.upcomingRows(for: car.id, limit: 3)
    }

    init(
        car: CarModel,
        service: (any VehicleServiceProtocol)? = nil,
        dataBase: (any VehicleRepositoryProtocol)? = nil,
        maintenance: MaintenanceService? = nil
    ) {
        self.service = service ?? ParallelumService()
        self.dataBase = dataBase ?? DataService.shared
        self.maintenance = maintenance ?? MaintenanceService.shared
        self.car = car

        loadPhoto()
    }

    private func loadPhoto() {
        carImage = UIImage(data: car.photo)
    }

    func fetchInformations() async {
        do {
            let allCars = try await dataBase.fetchAll()

            if let updatedCar = allCars.first(where: { $0.id == car.id }) {
                self.car = updatedCar
                loadPhoto()
            }
        } catch {
            Logger.database.error("Error on fetch informations of vehicle: \(error)")
        }
    }

    func delete() async {
        do {
            try await dataBase.delete(car)
        } catch {
            Logger.database.error("Error on delete vehicle: \(error)")
        }
    }

    func updateKilometers() async {
        do {
            try await dataBase.update(car)
        } catch {
            Logger.database.error("Error on update vehicle kilometers: \(error)")
        }
    }

    func textLimit(text: String, limit: Int = 20) -> String {
        if text.count > limit {
            return String(text.prefix(limit))
        }

        return text
    }
}
