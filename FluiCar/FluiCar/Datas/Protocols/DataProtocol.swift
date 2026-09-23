//
//  DataRepo.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 20/09/26.
//
protocol VehicleRepositoryProtocol {
    func fetchAll() async throws -> [Vehicle]
    func save(_ vehicle: Vehicle) async throws
    func delete(_ vehicle: Vehicle) async throws
    func update(_ vehicle: Vehicle) async throws
}
