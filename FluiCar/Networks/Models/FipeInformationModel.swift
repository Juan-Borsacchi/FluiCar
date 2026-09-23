//
//  FipeInformationsModel.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 23/09/26.
//
struct FipeInformationRequest {
    let vehicleType : String
    let brandId : Int
    let modelId : Int
    let yearId : String
}
struct PriceHistoryResponse: Decodable {
    let price: String
    let referenceMonth: String
}

struct FipeInformationResponse: Decodable {
    let brand: String
    let codeFipe: String
    let fuel: String
    let fuelAcronym: String
    let model: String
    let modelYear: Int
    let price: String
    let priceHistory: [PriceHistoryResponse]?
    let referenceMonth: String
    let vehicleType: Int
}
