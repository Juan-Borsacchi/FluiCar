//
//  Ano.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 20/09/26.
//

struct YearRequest: Codable {
    let vehicleType: String
    let brandId: Int
    let modelId: Int
}
struct YearResponse: Decodable {
    let code: String
    let name: String
}

