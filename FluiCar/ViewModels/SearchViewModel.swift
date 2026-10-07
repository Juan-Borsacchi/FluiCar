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
    private let service: MaintenanceService
    var searchText: String = ""
    
    init(service: MaintenanceService? = nil) {
        self.service = service ?? MaintenanceService.shared
    }
    
    var allCars: [CarModel] {
        service.cars
    }
    
    var allTasks: [CarTaskModel] {
        service.cars.flatMap { $0.tasks }
    }
    
    var allTutorials: [TaskType] {
        TaskType.automaticTypes
    }
    
    var filtredCars: [CarModel] {
        if searchText.isEmpty { return allCars }
        return allCars.filter {
            $0.name.localizedStandardContains(searchText) ||
            $0.brand.localizedStandardContains(searchText)
        }
    }
    
    var filtredTasks: [MaintenanceRow] {
            let customTasks = service.cars.flatMap { $0.tasks }.filter { $0.isAutomatic == false }
            let filteredCustom = searchText.isEmpty ? customTasks : customTasks.filter {
                $0.title.localizedStandardContains(searchText) ||
                $0.vehicleName.localizedStandardContains(searchText) ||
                ($0.textDescription?.localizedStandardContains(searchText) == true)
            }
            let customRows = filteredCustom.map { MaintenanceRow(task: $0) }
            
            let automaticTasks = service.automaticTasks
            let filteredAuto = searchText.isEmpty ? automaticTasks : automaticTasks.filter { task in
                let carName = service.carName(for: task.carID) ?? ""
                return task.type.maintenanceTitle.localizedStandardContains(searchText) ||
                       carName.localizedStandardContains(searchText)
            }
            let autoRows = filteredAuto.compactMap { service.automaticRow(for: $0) }
            
            return customRows + autoRows
        }
    
    var filtredTutorials: [TaskType] {
        if searchText.isEmpty { return allTutorials }
        return allTutorials.filter {
            $0.tutorialShortcutTitle.localizedStandardContains(searchText)
        }
    }
    
    func loadData() async {
        if !service.hasLoaded {
            await service.load()
        }
    }
}
