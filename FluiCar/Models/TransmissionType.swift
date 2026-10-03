//
//  TransmissionTyoe.swift
//  FluiCar
//
//  Created by Leonardo Gonçalves da Silva on 02/10/26.
//
import Foundation

enum TransmissionType: String, CaseIterable {
    case automatic = "Automático"
    case manual = "Manual"
    case cvt = "CVT"
    case automated = "Automatizado"
    case unknown = "Não Informado"
    
   
}
    func getTransmission(from modelName: String) -> TransmissionType {
        let lowercasedModel = modelName.lowercased()
        
        if lowercasedModel.contains(" aut") || lowercasedModel.contains("automático") || lowercasedModel.contains("automatico") {
            return .automatic
        } else if lowercasedModel.contains(" mec") || lowercasedModel.contains("manual") {
            return .manual
        } else if lowercasedModel.contains("cvt") {
            return .cvt
        } else if lowercasedModel.contains("automatizado") {
            return .automated
        }
        
        return .unknown
    }
