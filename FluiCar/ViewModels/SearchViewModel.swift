//
//  SearchViewModel.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 06/10/26.
//
import SwiftUI
import Observation

@MainActor
@Observable
class SearchViewModel {
    private let dataBase: any VehicleRepositoryProtocol
    var searchText: String = ""
    
    var allCars: [CarModel] = []
    var allTasks: [CarTaskModel] = []
    var allTutorials: [TutorialItem] = []
    
    init(dataBase: any VehicleRepositoryProtocol) {
            self.dataBase = dataBase
        }
    var filtredCars: [CarModel] {
        if searchText.isEmpty {return allCars}
        return allCars.filter {$0.name.localizedCaseInsensitiveContains(searchText) || $0.brand.localizedCaseInsensitiveContains(searchText)}
    }
    var filtredTasks: [CarTaskModel] {
        if searchText.isEmpty {return allTasks}
        return allTasks.filter{$0.title.localizedCaseInsensitiveContains(searchText)}
    }
    var filtredTutorials: [TutorialItem] {
        if searchText.isEmpty {return allTutorials}
        return allTutorials.filter{$0.title.localizedCaseInsensitiveContains(searchText)}
    }
    func loadData() async {
        do {
            let loadedVehicles = try await dataBase.fetchAll()
            self.allCars = loadedVehicles
            var allTasksExtracted: [CarTaskModel] = []
            for vehicle in loadedVehicles {
                allTasksExtracted.append(contentsOf: vehicle.tasks)
            }
            self.allTasks = allTasksExtracted
        }catch{
            print("Heavy error on search: \(error)")
        }
    }
}
