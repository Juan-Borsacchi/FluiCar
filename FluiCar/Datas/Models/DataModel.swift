//
//  DataModel.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 23/09/26.
//

import Foundation
import SwiftData

@Model
final class Cars {
    @Attribute(.unique) var id: UUID
    var photo: Data //Binary Data
    var name: String
    var brand: String
    var model: String
    var year: Int
    var fuel: String
    var fipeValue: String
    var kilometers: Int
    
    var insurance: Bool?
    var alarm: Date?
    var frequency: FrequencyType
    
    @Relationship(deleteRule: .cascade, inverse: \CarTask.car)
    var tasks: [CarTask] = []
    
    init(id: UUID, photo: Data, name: String, brand: String, model: String, year: Int, fuel: String, fipeValue: String, kilometers: Int, insurance: Bool? = nil, alarm: Date? = nil, frequency: FrequencyType, tasks: [CarTask] = []) {
        self.id = id
        self.photo = photo
        self.name = name
        self.brand = brand
        self.model = model
        self.year = year
        self.fuel = fuel
        self.fipeValue = fipeValue
        self.kilometers = kilometers
        self.insurance = insurance
        self.alarm = alarm
        self.frequency = frequency
        self.tasks = tasks
    }
}

@Model
final class CarTask {
    @Attribute(.unique) var id: UUID
        var title: String
        var textDescription: String?
        var startDate: Date?
        var endDate: Date?
        var frequency: String?
        var car: Cars?
        var isAutomatic: Bool
        var automaticTypeIdentifier: String?
        var lastCheckDate: Date?
        var selectedOption: String?
    
    init(id: UUID, title: String, textDescription: String? = nil, startDate: Date? = nil, endDate: Date? = nil, frequency: String? = nil, car: Cars? = nil, isAutomatic: Bool, automaticTypeIdentifier: String? = nil, lastCheckDate: Date? = nil, selectedOption: String? = nil) {
        self.id = id
        self.title = title
        self.textDescription = textDescription
        self.startDate = startDate
        self.endDate = endDate
        self.frequency = frequency
        self.car = car
        self.isAutomatic = isAutomatic
        self.automaticTypeIdentifier = automaticTypeIdentifier
        self.lastCheckDate = lastCheckDate
        self.selectedOption = selectedOption
    }
}
