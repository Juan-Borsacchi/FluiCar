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
    
    // Arrays para guardar as respostas da API
    var brands: [BrandResponse] = []
    var carModels: [ModelFipeResponse] = []
    var years: [YearResponse] = []
    
    // Variáveis que o usuário selecionou na tela
    var selectedBrandCode: String = ""
    var selectedModelCode: String = ""
    var selectedYearCode: String = ""
    
    var isLoading = false
    
    var fipeInfo: FipeInformationResponse?
    var showPriceAlert = false
    
    // Injetamos o seu serviço aqui (por padrão, usa a V2 que você criou)
    init(service: (any VehicleServiceProtocol)? = nil) {
            self.service = service ?? ParallelumService()
        }
    
    // MARK: - Funções de Busca
    func fetchBrands() {
        isLoading = true
        Task {
            do {
                // Na V2, o vehicleType deve ser "cars" em inglês
                let result = try await service.fetchBrands(vehicleType: "cars")
                self.brands = result
                self.isLoading = false
            } catch {
                print("Erro ao buscar marcas: \(error)")
                self.isLoading = false
            }
        }
    }
    
    func fetchModels(brandCode: String) {
        guard let brandId = Int(brandCode) else { return } // Converte a String para Int
        isLoading = true
        
        Task {
            do {
                let request = ModelFipeRequest(vehicleType: "cars", brandId: brandId)
                let result = try await service.fetchModels(request: request)
                self.carModels = result
                self.isLoading = false
            } catch {
                print("Erro ao buscar modelos: \(error)")
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
                print("✅ Sucesso! \(result.count) anos encontrados.")
            } catch {
                print("Erro ao buscar anos: \(error)")
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
                    print("Erro ao buscar informações da Fipe: \(error)")
                    self.isLoading = false
                }
            }
        }
}
