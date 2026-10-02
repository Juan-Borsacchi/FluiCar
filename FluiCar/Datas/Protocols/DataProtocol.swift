//
//  DataProtocol.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 20/09/26.
//
protocol VehicleRepositoryProtocol {
    func fetchAll() async throws -> [CarModel]
    func save(_ vehicle: CarModel) async throws
    func delete(_ vehicle: CarModel) async throws
    func update(_ vehicle: CarModel) async throws
    func addTask(_ task: CarTaskModel, to vehicle: CarModel) async throws
    func deleteTask(_ task: CarTaskModel) async throws
}
