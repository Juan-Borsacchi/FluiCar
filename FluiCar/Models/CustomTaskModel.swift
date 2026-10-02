//
//  CustomTaskModel.swift
//  FluiCar
//
//  Created by Assistente on 01/10/26.
//

import Foundation

struct CustomTaskModel: Identifiable, Codable {
    var id = UUID()
    var vehicleName: String
    var title: String
    var note: String
    var alarmDate: Date
    var frequency: String
}
