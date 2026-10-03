//
//  VihicleViewModel.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 30/09/26.
//
import SwiftUI
import Observation

@MainActor
@Observable
class VehicleViewModel {
    private let service: any VehicleServiceProtocol
    private let dataBase: any VehicleRepositoryProtocol
    var car: CarModel
    var carImage: UIImage? = nil
    var transmission: TransmissionType {
        return getTransmission(from: car.model)
    }

    init(car: CarModel,service: (any VehicleServiceProtocol)? = nil, dataBase: any VehicleRepositoryProtocol? = nil) {
        self.service = service ?? ParallelumService()
        self.dataBase = dataBase ?? DataService.shared
        self.car = car
        loadPhoto()
    }

    private func loadPhoto(){
        if  let image = UIImage(data: car.photo) {
            self.carImage = image
        }
    }
    
    func fetchInformations() async {
        do {
            let allCars = try await dataBase.fetchAll()
            if let updatedCar = allCars.first(where: { $0.id == car.id}) {
                self.car = updatedCar
                loadPhoto()
            }
        }catch {
            print("Error on updated informations of vehicle: \(error)")
        }
    }
    func delete() async {
        do {
            try await dataBase.delete(car)
        }catch {
            print("Error on delete vehicle: \(error)")
        }
    }
}
