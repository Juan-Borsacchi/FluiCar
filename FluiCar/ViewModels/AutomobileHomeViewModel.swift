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
    private let maintenance: MaintenanceService
    
    var cars: [CarModel] = []
    var hasLoaded = false // evita mostrar o estado vazio antes da primeira busca terminar
    
    init(
        dataBase: (any VehicleRepositoryProtocol)? = nil,
        maintenance: MaintenanceService? = nil
    ) {
        self.dataBase = dataBase ?? DataService.shared
        self.maintenance = maintenance ?? MaintenanceService.shared
    }
    
    // Busca os veículos cadastrados no banco
    func loadCars() async {
        do {
            cars = try await dataBase.fetchAll()
        } catch {
            print("Erro ao carregar veículos: \(error)")
            cars = []
        }
        // Garante que as tarefas de cada carro existam antes de desenhar os cartões.
        await maintenance.load()
        hasLoaded = true
    }
    
    // Exclui o carro e recarrega a lista (o load também limpa as tarefas e lembretes dele)
    func deleteCar(_ car: CarModel) async {
        maintenance.cancelReminders(for: car)
        do {
            try await dataBase.delete(car)
        } catch {
            print("Erro ao excluir veículo: \(error)")
        }
        await loadCars()
    }

    // Texto da próxima tarefa do carro (a mais próxima, incluindo as atrasadas)
    func nextTaskText(for car: CarModel) -> String {
        if let next = maintenance.upcomingRows(for: car.id, limit: 1).first {
            return "Próxima tarefa: \(next.title)"
        }
        return "Nenhuma tarefa agendada"
    }
}
