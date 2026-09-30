//
//  CarModel.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 20/09/26.
//
import Foundation

struct Car: Identifiable, Hashable {
    let id: UUID
    var photo: Data
    var name : String
    var brand: String
    var model: String
    var year: Int
    var fuel: String
    var kilometers: String
    var fipeValue: String
    
    var insurance: Bool?
    var alarm: Date?
    var frequency: FrequencyType
    
    var tasks: [CarTaskModel] = []
    
    func toCars() -> Cars{
        
        let tasksEntities = tasks.map { $0.toTasks() }
        
        return Cars(id: id, photo: photo, name: name, brand: brand, model: model, year: year, fuel: fuel, fipeValue: fipeValue, kilometers: Int(kilometers) ?? 0, insurance: insurance, alarm: alarm, frequency: frequency, tasks: tasksEntities)
    }
    
}

extension Cars {
    func toCar() -> Car {
        
        let tasksModels = tasks.map { $0.toTask() }
        
        return Car(id: id, photo: photo, name: name, brand: brand, model: model, year: year, fuel: fuel, kilometers: String(kilometers), fipeValue: fipeValue, insurance: insurance, alarm: alarm, frequency: frequency, tasks: tasksModels)
        
    }
}
