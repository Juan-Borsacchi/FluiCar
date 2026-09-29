//
//  AddVehicleViewModel.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 20/09/26.
//
import SwiftUI
import Observation

@MainActor
@Observable
class AddVehicleViewModel {
    private let service: any VehicleServiceProtocol
    private let dataBase: any VehicleRepositoryProtocol
    // Arrays para guardar as respostas da API
    var brands: [BrandResponse] = []
    var carModels: [ModelFipeResponse] = []
    var years: [YearResponse] = []
    
    
    // Variáveis que o usuário selecionou na tela
    var selectedBrandCode: String = ""
    var selectedModelCode: String = ""
    var selectedYearCode: String = ""
    
    var carName: String = ""
    var carPhoto: Data? = nil
    var insurance = false
    var alarm: Date = Date()
    var frequency: FrequencyType = .none
    
    var isLoading = false
    
    var fipeInfo: FipeInformationResponse?
    var showPriceAlert = false
    
    // Injetando o serviço
    init(service: (any VehicleServiceProtocol)? = nil, dataBase: any VehicleRepositoryProtocol? = nil) {
            self.service = service ?? ParallelumService()
            self.dataBase = dataBase ?? DataService.shared
        }
    
    // MARK: - Funções de Busca
    func fetchBrands() {
        isLoading = true
        Task {
            do {
                let result = try await service.fetchBrands(vehicleType: "cars")
                self.brands = result
                self.isLoading = false
            } catch {
                print("Error on fetch brand: \(error)")
                self.isLoading = false
            }
        }
    }
    
    func fetchModels(brandCode: String) {
        guard let brandId = Int(brandCode) else { return }
        isLoading = true
        
        Task {
            do {
                let request = ModelFipeRequest(vehicleType: "cars", brandId: brandId)
                let result = try await service.fetchModels(request: request)
                self.carModels = result
                self.isLoading = false
            } catch {
                print("Error on fetch car models: \(error)")
                self.isLoading = false
            }
        }
    }
    
    func fetchYears(brandCode: String, modelCode: String) {
        guard let brandId = Int(brandCode), let modelId = Int(modelCode) else { return }
        isLoading = true
        
        Task {
            do {
                let request = YearRequest(vehicleType: "cars", brandId: brandId, modelId: modelId)
                let result = try await service.fetchYears(request: request)
                self.years = result
                self.isLoading = false
                print("Success! \(result.count) years found.")
            } catch {
                print("Error on fetch years: \(error)")
                self.isLoading = false
            }
        }
    }
    
    func fetchFipeInformation(brandCode: String, modelCode: String, yearCode: String) {
        guard let brandId = Int(brandCode), let modelId = Int(modelCode) else { return }
        
        isLoading = true
        
        Task {
            do {
                let request = FipeInformationRequest(
                    vehicleType: "cars",
                    brandId: brandId,
                    modelId: modelId,
                    yearId: yearCode
                )
                
                let result = try await service.fetchFipeInformation(request: request)
                
                self.fipeInfo = result
                self.showPriceAlert = true
                self.isLoading = false
            } catch {
                print("Error on fetch FIPE informations: \(error)")
                self.isLoading = false
            }
        }
    }
    
    func save() async {
        guard let brandId = Int(selectedBrandCode), let modelId = Int(selectedModelCode) else { return }
        isLoading = true
        do {
            // 1. Busca as informações completas da FIPE para garantir o preço exato
            let request = FipeInformationRequest(
                vehicleType: "cars",
                brandId: brandId,
                modelId: modelId,
                yearId: selectedYearCode
            )
            
            _ = try await service.fetchFipeInformation(request: request)
            
//            let vehicleToSave = Vehicle(
//                name: carName.isEmpty ? fipeResult.model : carName,
//                brand: fipeResult.brand,
//                model: fipeResult.model,
//                year: fipeResult.modelYear,
//                price: fipeResult.price,
//                photoData: carPhoto,
//                hasInsurance: insurance,
//                alarm: alarm,
//                frequency: frequency
//            )
//            await dataBase.save(vehicleToSave)
            print("Data saved")
            
            isLoading = false
        }catch {
            print("Error ao buscar FIPE para salvar: \(error)")
            isLoading = false

        }
    }
}
