//
//  VehicleModel.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 20/09/26.
//
import Foundation

struct Vehicle: Identifiable, Hashable {
    let id: UUID
    var plate: String
    var brand: String
    var model: String
    var year: Int
    var fipeValue: String
}
