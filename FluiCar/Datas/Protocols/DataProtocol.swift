//
//  DataProtocol.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 20/09/26.
//
protocol VehicleRepositoryProtocol {
    func fetchAll() async throws -> [Car]
    func save(_ vehicle: Car) async throws
    func delete(_ vehicle: Car) async throws
    func update(_ vehicle: Car) async throws
    func addTask(_ task: CarTaskModel, to vehicle: Car) async throws
    func deleteTask(_ task: CarTaskModel) async throws
}
