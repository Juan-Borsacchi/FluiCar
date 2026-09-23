//
//  ModeloFipe.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 20/09/26.
//
struct ModelFipeRequest: Codable {
    let vehicleType: String
    let brandId: Int
}

struct ModelFipeResponse: Decodable {
    let code: String
    let name: String
}
struct ModelContainerResponse: Decodable {
    let models: [ModelFipeResponse]
}
