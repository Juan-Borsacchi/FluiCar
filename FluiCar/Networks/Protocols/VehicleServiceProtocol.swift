//
//  VehicleProtocol.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 20/09/26.
//
import Foundation

protocol VehicleServiceProtocol{
    func fetchBrands(vehicleType: String) async throws -> [BrandResponse]
    func fetchModels(request: ModelFipeRequest) async throws -> [ModelFipeResponse]
    func fetchYears(request: YearRequest) async throws -> [YearResponse]
    func fetchFipeInformation(request: FipeInformationRequest) async throws -> FipeInformationResponse
}
