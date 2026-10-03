//
//  DataService.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 23/09/26.
//

import Foundation
import SwiftData

@MainActor
final class DataService: VehicleRepositoryProtocol {
    
    static let shared = DataService()
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    private init() {
            do {
                let schema = Schema([Cars.self, CarTask.self])
                let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
               
                self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
                self.modelContext = modelContainer.mainContext
            } catch {
                // Em vez de crashar a app com fatalError, criamos um contentor em memória temporário como fallback seguro
                let schema = Schema([Cars.self, CarTask.self])
                let fallbackConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
                do {
                    self.modelContainer = try ModelContainer(for: schema, configurations: [fallbackConfig])
                    self.modelContext = modelContainer.mainContext
                    print("Aviso: Banco recriado em memória devido a erro de migração: \(error)")
                } catch {
                    fatalError("Erro crítico absoluto ao inicializar o ModelContainer: \(error)")
                }
            }
        }
    
    func fetchAll() async throws -> [CarModel] {
        let descriptor = FetchDescriptor<Cars>(sortBy: [SortDescriptor(\.name)])
        let carEntities = try modelContext.fetch(descriptor)
        
        return carEntities.map { $0.toCarModel() }
    }
    
    func save(_ vehicle: CarModel) async throws {
        let newCar = vehicle.toEntity()
        modelContext.insert(newCar)
        try modelContext.save()
    }
    
    func update(_ vehicle: CarModel) async throws {
            let vehicleID = vehicle.id
            let predicate = #Predicate<Cars> { $0.id == vehicleID }
            var descriptor = FetchDescriptor<Cars>(predicate: predicate)
            descriptor.fetchLimit = 1
            
            let fetchedEntities = try modelContext.fetch(descriptor)
            
            if let existingCar = fetchedEntities.first {
                existingCar.photo = vehicle.photo
                existingCar.name = vehicle.name
                existingCar.brand = vehicle.brand
                existingCar.model = vehicle.model
                existingCar.year = vehicle.year
                existingCar.fuel = vehicle.fuel
                existingCar.fipeValue = vehicle.fipeValue
                existingCar.kilometers = Int(vehicle.kilometers) ?? 0
                
                existingCar.insurance = vehicle.insurance
                existingCar.alarm = vehicle.alarm
                existingCar.frequency = vehicle.frequency
                
                try modelContext.save()
            }
        }
    
    func delete(_ vehicle: CarModel) async throws {
        let vehicleID = vehicle.id
        let predicate = #Predicate<Cars> { $0.id == vehicleID }
        var descriptor = FetchDescriptor<Cars>(predicate: predicate)
        descriptor.fetchLimit = 1
        
        let fetchedEntities = try modelContext.fetch(descriptor)
        
        if let existingCar = fetchedEntities.first {
            modelContext.delete(existingCar)
            try modelContext.save()
        }
    }
    
    func addTask(_ task: CarTaskModel, to vehicle: CarModel) async throws {
        let vehicleID = vehicle.id
        let predicate = #Predicate<Cars> { $0.id == vehicleID }
        var descriptor = FetchDescriptor<Cars>(predicate: predicate)
        descriptor.fetchLimit = 1
        
        let fetchedEntities = try modelContext.fetch(descriptor)
        
        if let existingCar = fetchedEntities.first {
            let newTask = task.toEntity()
            existingCar.tasks.append(newTask)
            try modelContext.save()
        }
    }
    
    func deleteTask(_ task: CarTaskModel) async throws {
            let taskID = task.id
            let predicate = #Predicate<CarTask> { $0.id == taskID }
            var descriptor = FetchDescriptor<CarTask>(predicate: predicate)
            descriptor.fetchLimit = 1
            
            let fetchedTasks = try modelContext.fetch(descriptor)
            
            if let taskToDelete = fetchedTasks.first {
                modelContext.delete(taskToDelete)
                try modelContext.save()
            }
        }
    
    
}

extension Cars {
    func toCarModel() -> CarModel {
        let tasksModels = self.tasks.map { $0.toCarTaskModel() }
        
        return CarModel(
            id: self.id,
            photo: self.photo,
            name: self.name,
            brand: self.brand,
            model: self.model,
            year: self.year,
            fuel: self.fuel,
            kilometers: String(self.kilometers),
            fipeValue: self.fipeValue,
            insurance: self.insurance,
            alarm: self.alarm,
            frequency: self.frequency,
            tasks: tasksModels
        )
    }
}

extension CarModel {
    func toEntity() -> Cars {
        let tasksEntities = self.tasks.map { $0.toEntity() }
        
        return Cars(
            id: self.id,
            photo: self.photo,
            name: self.name,
            brand: self.brand,
            model: self.model,
            year: self.year,
            fuel: self.fuel,
            fipeValue: self.fipeValue,
            kilometers: Int(self.kilometers) ?? 0,
            insurance: self.insurance,
            alarm: self.alarm,
            frequency: self.frequency,
            tasks: tasksEntities
        )
    }
}

extension CarTask {
    func toCarTaskModel() -> CarTaskModel {
        return CarTaskModel(
            id: self.id,
            title: self.title,
            textDescription: self.textDescription,
            startDate: self.startDate,
            endDate: self.endDate,
            frequency: self.frequency
        )
    }
}

extension CarTaskModel {
    func toEntity() -> CarTask {
        return CarTask(
            id: self.id,
            title: self.title,
            textDescription: self.textDescription,
            startDate: self.startDate,
            endDate: self.endDate,
            frequence: self.frequency
        )
    }
}


