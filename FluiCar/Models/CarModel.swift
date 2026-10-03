//
//  CarModel.swift
//  Challenge5
//
//  Created by Leonardo Gonçalves da Silva on 20/09/26.
//
import Foundation

struct CarModel: Identifiable, Hashable {
    let id: UUID
    var photo: Data
    var name : String
    var brand: String
    var model: String
    var year: Int
    var fuel: String
    var kilometers: String
    var fipeValue: String
    
    var insurance: Bool?
    var alarm: Date?
    var frequency: FrequencyType
    
    var tasks: [CarTaskModel] = []
    
   
    
}

