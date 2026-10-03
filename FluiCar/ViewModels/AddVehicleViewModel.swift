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
    var carToEdit: CarModel?
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
    
    var isLoading = false
    
    var fipeInfo: FipeInformationResponse?
    var showPriceAlert = false
    var carUIImage: UIImage? = nil {
            didSet {
                if carUIImage == nil {
                    self.carPhotoData = nil
                }
            }
        }
        
        private var carPhotoData: Data? = nil
    init(car: CarModel? = nil, service: (any VehicleServiceProtocol)? = nil, dataBase: any VehicleRepositoryProtocol? = nil) {
        self.service = service ?? ParallelumService()
        self.dataBase = dataBase ?? DataService.shared
        self.carToEdit = car
        
        if let car = car {
            self.carName = car.name
            self.insurance = car.insurance ?? false
            self.alarm = car.alarm ?? Date()
            self.frequency = car.frequency
            self._carPhotoData = car.photo
            
            let numbersOnly = car.kilometers.filter { $0.isNumber }
            if let number = Int(numbersOnly) {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.locale = Locale(identifier: "pt_BR")
                if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
                    self.carKilometers = "\(formattedNumber) km"
                }
            }
            if let loadedImage = UIImage(data: car.photo){
                self.carUIImage = loadedImage
                self.carPhotoData = car.photo
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
        isLoading = true
            do {
                let cleanKilometers = carKilometers.filter { $0.isNumber }
                let photoToSave = carUIImage?.jpegData(compressionQuality: 0.8) ?? Data()
                if let existingCar = carToEdit {
                    
                    var updatedCar = existingCar
                    updatedCar.name = carName
                    updatedCar.photo = photoToSave
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
                    print("Data updated")
                    
                }else{
                    guard let brandId = Int(selectedBrandCode), let modelId = Int(selectedModelCode) else {
                        isLoading = false
                        return
                    }

                    // 1. Busca as informações completas da FIPE para garantir o preço exato
                    let request = FipeInformationRequest(
                        vehicleType: "cars",
                        brandId: brandId,
                        modelId: modelId,
                        yearId: selectedYearCode
                    )
                    
                    let fipeResult = try await service.fetchFipeInformation(request: request)
                    
                    
                    let vehicleToSave = CarModel(
                        id: UUID(),
                        photo: carPhotoData ?? Data(),
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
                    print("Data saved")
                    
                    isLoading = false
                }
            } catch {
                print("Error ao buscar FIPE para salvar: \(error)")
                isLoading = false
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
            guard let car = carToEdit else { return }
            
        fetchBrands()
            guard let savedBrand = brands.first(where: { $0.name == car.brand }) else { return }
            selectedBrandCode = String(savedBrand.code)
            
        fetchModels(brandCode: selectedBrandCode)
            guard let savedModel = carModels.first(where: { $0.name == car.model }) else { return }
            selectedModelCode = String(savedModel.code)
            
        fetchYears(brandCode: selectedBrandCode, modelCode: selectedModelCode)
            if let savedYear = years.first(where: {
                $0.name.contains(car.year.description) || (car.year == 32000 && $0.name.contains("32000"))
            }) {
                selectedYearCode = String(savedYear.code)
            }
        }
    func onAppear() async {
        if carToEdit != nil {
            await loadEditData()
        } else if brands.isEmpty {
            fetchBrands()
        }
    }
}
