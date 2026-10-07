//
//  CarTaskModel.swift
//  FluiCar
//
//  Created by Juan Gabriel Borsacchi Marques on 28/09/26.
//

import Foundation

struct CarTaskModel: Identifiable, Hashable {
    let id: UUID
    var title: String
    var textDescription: String?
    var startDate: Date?
    var endDate: Date?
    var frequency: String?
    var vehicleName: String
    var isAutomatic: Bool = false
    var automaticTypeIdentifier: String? = nil
    var lastCheckDate: Date? = nil
    var selectedOption: String? = nil
    var isInsurance: Bool? = nil
}


