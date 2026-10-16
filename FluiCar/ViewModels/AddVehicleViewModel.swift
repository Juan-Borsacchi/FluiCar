//
//  AddVehicleViewModel.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 20/09/26.
//
import SwiftUI
import Observation
import OSLog

@MainActor
@Observable
class AddVehicleViewModel {
    private let service: any VehicleServiceProtocol
    private let dataBase: any VehicleRepositoryProtocol
    private let maintenance: MaintenanceService
    
    var isInitialLoading = false
    var isLoading = false
    var carToEdit: CarModel? {
        didSet {
            // Se o carro for injetado depois do init, força o carregamento!
            if carToEdit != nil {
                Task {
                    await loadEditData()
                }
            }
        }
    }
    
    var isChangingFipe: Bool = false
    // Arrays para guardar as respostas da API
    var brands: [BrandResponse] = []
    var carModels: [ModelFipeResponse] = []
    var years: [YearResponse] = []
    
    // Variáveis que o usuário selecionou na tela
    var selectedBrandCode: String = ""
    var selectedModelCode: String = ""
    var selectedYearCode: String = "" {
        didSet {
            if selectedYearCode.contains("32000") {
                carKilometers = "0 km"
            } else if carKilometers == "0 km"{
                carKilometers = ""
            }
        }
    }
    
    var carKilometers: String = ""
    var carName: String = ""
    var insurance = false
    var alarm: Date = Date()
    var frequency: FrequencyType = .none
    
    var fipeInfo: FipeInformationResponse?
    var showPriceAlert = false
    var carUIImage: UIImage?
    var didRemovePhoto = false

    init(car: CarModel? = nil, service: (any VehicleServiceProtocol)? = nil, dataBase: (any VehicleRepositoryProtocol)? = nil, maintenance: MaintenanceService? = nil) {
        self.service = service ?? ParallelumService()
        self.dataBase = dataBase ?? DataService.shared
        self.maintenance = maintenance ?? MaintenanceService.shared
        self.carToEdit = car
        
        if let car = car {
            self.carName = car.name
            self.insurance = car.insurance ?? false
            self.alarm = car.alarm ?? Date()
            self.frequency = car.frequency

            let numbersOnly = car.kilometers.filter { $0.isNumber }

            if let number = Int(numbersOnly) {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.locale = Locale(identifier: "pt_BR")

                if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
                    self.carKilometers = "\(formattedNumber) km"
                }
            }

            if let loadedImage = UIImage(data: car.photo) {
                self.carUIImage = loadedImage
            }
            
            // Força o carregamento no init se o carro já existir
            Task {
                await self.loadEditData()
            }
        }
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
                Logger.network.error("Error on fetch brand: \(error)")
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
                Logger.network.error("Error on fetch car models: \(error)")
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
                Logger.network.debug("Success! \(result.count) years found.")
            } catch {
                Logger.network.error("Error on fetch years: \(error)")
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
                Logger.network.error("Error on fetch FIPE informations: \(error)")
                self.isLoading = false
            }
        }
    }

    func save() async -> CarModel? {
        isLoading = true
        do {
            let cleanKilometers = carKilometers.filter { $0.isNumber }
            let photoToSave = carUIImage?.jpegData(compressionQuality: 0.8) ?? Data()
            
            if let existingCar = carToEdit {
                var updatedCar = existingCar
                updatedCar.name = carName

                if didRemovePhoto {
                    updatedCar.photo = Data()
                } else if let newPhoto = carUIImage?.jpegData(compressionQuality: 0.8) {
                    updatedCar.photo = newPhoto
                } else {
                    updatedCar.photo = existingCar.photo
                }

                updatedCar.kilometers = cleanKilometers
                updatedCar.insurance = insurance
                updatedCar.alarm = alarm
                updatedCar.frequency = frequency
                
                if let brandId = Int(selectedBrandCode), let modelId = Int(selectedModelCode), !selectedYearCode.isEmpty {
                    let request = FipeInformationRequest(vehicleType: "cars", brandId: brandId, modelId: modelId, yearId: selectedYearCode)
                    let fipeResult = try await service.fetchFipeInformation(request: request)
                    
                    updatedCar.brand = fipeResult.brand
                    updatedCar.model = fipeResult.model
                    updatedCar.year = fipeResult.modelYear
                    updatedCar.fuel = fipeResult.fuel
                    updatedCar.fipeValue = fipeResult.price
                    updatedCar.name = carName.isEmpty ? fipeResult.model : carName
                }
                
                try await dataBase.update(updatedCar)
                await maintenance.syncInsuranceTask(for: updatedCar)
                isLoading = false
                Logger.interface.debug("Data updated")
                return updatedCar
                
            } else {
                guard let brandId = Int(selectedBrandCode), let modelId = Int(selectedModelCode) else {
                    isLoading = false
                    return nil
                }

                let request = FipeInformationRequest(
                    vehicleType: "cars",
                    brandId: brandId,
                    modelId: modelId,
                    yearId: selectedYearCode
                )
                
                let fipeResult = try await service.fetchFipeInformation(request: request)
                
                let vehicleToSave = CarModel(
                    id: UUID(),
                    photo: photoToSave,
                    name: carName.isEmpty ? fipeResult.model : carName,
                    brand: fipeResult.brand,
                    model: fipeResult.model,
                    year: fipeResult.modelYear,
                    fuel: fipeResult.fuel,
                    kilometers: cleanKilometers,
                    fipeValue: fipeResult.price,
                    insurance: insurance,
                    alarm: alarm,
                    frequency: frequency
                )
                
                try await dataBase.save(vehicleToSave)
                await maintenance.syncInsuranceTask(for: vehicleToSave)
                isLoading = false
                Logger.interface.debug("Data saved")
                return vehicleToSave
            }
        } catch {
            Logger.network.error("Error ao buscar FIPE para salvar: \(error)")
            isLoading = false
            return nil
        }
    }
    
    func formatKilometers(oldValue: String, newValue: String) {
        let oldNumbers = oldValue.filter { $0.isNumber }
        var newNumbers = newValue.filter { $0.isNumber }
        
        if newValue.count < oldValue.count && oldNumbers == newNumbers {
            if !newNumbers.isEmpty {
                newNumbers.removeLast()
            }
        }
        if newNumbers.count > 7 {
            newNumbers = String(newNumbers.prefix(7))
        }
        
        if let number = Int(newNumbers) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale(identifier: "pt_BR")
            
            if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
                self.carKilometers = "\(formattedNumber) km"
            }
        } else {
            self.carKilometers = ""
        }
    }
    
    func formatPickerYear(_ yearName: String) -> String{
        if yearName.contains("32000") {
            return "Novo de fábrica"
        }
        return yearName
    }
    
    func loadEditData() async {
        guard let car = carToEdit else {
            isInitialLoading = false
            return
        }
        
        isLoading = true
        isInitialLoading = true
        
        do {
            let loadedBrands = try await service.fetchBrands(vehicleType: "cars")
            self.brands = loadedBrands
            
            if let savedBrand = loadedBrands.first(where: { $0.name == car.brand }) {
                self.selectedBrandCode = String(savedBrand.code)
                
                let modelRequest = ModelFipeRequest(vehicleType: "cars", brandId: Int(savedBrand.code)!)
                let loadedModels = try await service.fetchModels(request: modelRequest)
                self.carModels = loadedModels
                
                if let savedModel = loadedModels.first(where: { $0.name == car.model }) {
                    self.selectedModelCode = String(savedModel.code)
                    
                    let yearRequest = YearRequest(vehicleType: "cars", brandId: Int(savedBrand.code)!, modelId: Int(savedModel.code)!)
                    let loadedYears = try await service.fetchYears(request: yearRequest)
                    self.years = loadedYears
                    
                    if let savedYear = loadedYears.first(where: {
                        $0.name.contains(car.year.description) || (car.year == 32000 && $0.name.contains("32000"))
                    }) {
                        self.selectedYearCode = String(savedYear.code)
                    }
                }
            }
        } catch {
            Logger.database.error("Erro ao carregar dados de edição: \(error)")
        }
        
        isLoading = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isInitialLoading = false
                }
    }
    
    func onAppear() async {
        if carToEdit == nil && brands.isEmpty {
            isInitialLoading = false
            fetchBrands()
        }
    }
    func textLimit(text: String, limit: Int = 20) -> String {
            if text.count > limit {
                return String(text.prefix(limit))
            }
            return text
        }
}
