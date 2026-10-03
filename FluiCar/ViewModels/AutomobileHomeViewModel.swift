//
//  AutomobileHomeViewModel.swift
//  FluiCar
//
//  Created by Isabella Avelina on 02/10/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
class AutomobileHomeViewModel {
    private let dataBase: any VehicleRepositoryProtocol
    
    var cars: [CarModel] = []
    var hasLoaded = false // evita mostrar o estado vazio antes da primeira busca terminar
    
    init(dataBase: (any VehicleRepositoryProtocol)? = nil) {
        self.dataBase = dataBase ?? DataService.shared
    }
    
    // Busca os veículos cadastrados no banco
    func loadCars() async {
        do {
            cars = try await dataBase.fetchAll()
        } catch {
            print("Erro ao carregar veículos: \(error)")
            cars = []
        }
        hasLoaded = true
    }
    
    // Texto da próxima tarefa do carro (a mais próxima a partir de hoje)
    func nextTaskText(for car: CarModel) -> String {
        let now = Date()
        let upcoming = car.tasks
            .compactMap { task -> (CarTaskModel, Date)? in
                guard let date = task.endDate ?? task.startDate, date >= now else { return nil }
                return (task, date)
            }
            .min { $0.1 < $1.1 }
        
        if let next = upcoming {
            return "Próxima tarefa: \(next.0.title)"
        }
        return "Nenhuma tarefa agendada"
    }
}
