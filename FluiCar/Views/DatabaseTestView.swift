//
//  DatabaseTestView.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 28/09/26.
//

import SwiftUI
import SwiftData

struct DatabaseTestView: View {
    // Estado para guardar os carros que vêm do banco
    @State private var cars: [Car] = []
    
    // Agora usamos a instância única (Singleton) que criamos no DataService
    private let service = DataService.shared
    
    var body: some View {
        NavigationView {
            VStack {
                // Lista para mostrar os carros salvos
                List(cars) { car in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(car.brand) \(car.name)")
                            .font(.headline)
                        
                        Text("Ano: \(car.year) | Combustível: \(car.fuel)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Fipe: \(car.fipeValue) | KM: \(car.kilometers)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // Mostrando o Seguro e a quantidade de Tarefas
                        Text("Seguro: \(car.insurance == true ? "Sim" : "Não") | Tarefas: \(car.tasks.count)")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                }
                
                // Botões de Teste
                ScrollView {
                    VStack(spacing: 15) {
                        Button("1. Adicionar Carro Falso") {
                            Task { await addMockCar() }
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("2. Atualizar Primeiro Carro") {
                            Task { await updateFirstCar() }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                        
                        Button("3. Deletar Primeiro Carro") {
                            Task { await deleteFirstCar() }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        
                        // Botão para testar a adição de Tarefas
                        Button("4. Adicionar Tarefa ao 1º Carro") {
                            Task { await addTaskToFirstCar() }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.indigo)
                    }
                    .padding()
                }
            }
            .navigationTitle("Teste do Banco")
            // Quando a tela carregar, busca os dados usando o serviço
            .task {
                await fetchCars()
            }
        }
    }
    
    // MARK: - Funções de Teste
    
    func fetchCars() async {
        do {
            cars = try await service.fetchAll()
            print("Sucesso: \(cars.count) carros encontrados.")
        } catch {
            print("Erro ao buscar: \(error)")
        }
    }
    
    func addMockCar() async {
        // Criando um carro com as propriedades atualizadas
        let newCar = Car(
            id: UUID(),
            photo: Data(),
            name: "Civic",
            brand: "Honda",
            model: "Sedan",
            year: Int.random(in: 2010...2024),
            fuel: "Flex",
            kilometers: "50000",
            fipeValue: "R$ 120.000,00",
            insurance: Bool.random(), // Sorteia true ou false para testar o seguro
            alarm: nil,
            frequency: nil,
            tasks: [] // Começa sem tarefas
        )
        
        do {
            try await service.save(newCar)
            print("Carro adicionado com sucesso!")
            await fetchCars()
        } catch {
            print("Erro ao salvar: \(error)")
        }
    }
    
    func updateFirstCar() async {
        guard var firstCar = cars.first else { return }
        
        firstCar.name = "Civic Atualizado!"
        firstCar.fipeValue = "R$ 150.000,00"
        firstCar.kilometers = "60000"
        
        // Inverte o status do seguro para ver atualizando na tela
        firstCar.insurance = !(firstCar.insurance ?? false)
        
        do {
            try await service.update(firstCar)
            print("Carro atualizado com sucesso!")
            await fetchCars()
        } catch {
            print("Erro ao atualizar: \(error)")
        }
    }
    
    func deleteFirstCar() async {
        guard let firstCar = cars.first else { return }
        
        do {
            try await service.delete(firstCar)
            print("Carro deletado com sucesso!")
            await fetchCars()
        } catch {
            print("Erro ao deletar: \(error)")
        }
    }
    
    // Testando salvar uma tarefa vinculada ao carro
    func addTaskToFirstCar() async {
        guard let firstCar = cars.first else { return }
        
        let novaTarefa = CarTaskModel(
            id: UUID(),
            title: "Revisão \(Int.random(in: 1...10))",
            textDescription: "Troca de óleo e filtro",
            startDate: Date(),
            endDate: nil,
            frequency: "10.000 km"
        )
        
        do {
            try await service.addTask(novaTarefa, to: firstCar)
            print("Tarefa adicionada com sucesso!")
            await fetchCars() // Atualiza a tela para mostrar a contagem subir
        } catch {
            print("Erro ao adicionar tarefa: \(error)")
        }
    }
}

#Preview {
    DatabaseTestView()
}
