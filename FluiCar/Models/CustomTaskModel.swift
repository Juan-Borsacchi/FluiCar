//
//  CustomTaskModel.swift
//  FluiCar
//
//  Created by Isabella Avelina on 01/10/26.
//

import Foundation

struct CustomTaskModel: Identifiable, Codable, Hashable {
    var id = UUID()
    var vehicleID: UUID
    var title: String
    var note: String
    var alarmDate: Date
    var frequency: ReminderRepeat
    var isInsurance: Bool? = nil
}

