//
//  TaskTypeMaintenance.swift.swift
//  FluiCar
//
//  Created by Isabella Avelina on 06/10/26.
//

//definindo regras de manutenção
import Foundation


extension TaskType {
    static let automaticTypes: [TaskType] = [
        .oilChange, .waterCheck, .tireCalibration, .brakeCheck, .batteryCheck
    ]

    var maintenanceTitle: String {
        switch self {
        case .oilChange: return "Troca de Óleo"
        case .oilCheck: return "Verificação de Óleo"
        case .waterCheck: return "Água do Radiador"
        case .brakeCheck: return "Verificação de Freios"
        case .tireCalibration: return "Calibragem de Pneus"
        case .batteryCheck: return "Bateria"
        }
    }

    var interval: DateComponents {
        switch self {
        case .oilChange: return DateComponents(month: 6)
        case .oilCheck: return DateComponents(month: 1)
        case .waterCheck: return DateComponents(month: 3)
        case .brakeCheck: return DateComponents(month: 4)
        case .tireCalibration: return DateComponents(day: 15)
        case .batteryCheck: return DateComponents(month: 12)
        }
    }

    func nextDueDate(after date: Date, calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: interval, to: date) ?? date
    }

    var optionsTitle: String {
        switch self {
        case .oilChange, .oilCheck: return "Tipo de óleo"
        case .waterCheck: return "Fluido utilizado"
        case .tireCalibration: return "Tipo de calibragem"
        case .batteryCheck: return "Estado da bateria"
        case .brakeCheck: return "Estado dos freios"
        }
    }

    var options: [String] {
        switch self {
        case .oilChange, .oilCheck:
            return [
                "Mineral", "Sintético", "Semi-sintético",
                "0W16", "0W20", "5W30", "5W40", "10W30", "10W40", "15W40", "20W50", "25W60"
            ]
        case .waterCheck:
            return [
                "Água Desmineralizada + aditivada",
                "Água aditivada",
                "Mistura simples",
                "Apenas Água Desmineralizada"
            ]
        case .tireCalibration:
            return ["Calibragem Padrão (30 PSI)", "Calibragem com Carga (32+ PSI)"]
        case .batteryCheck:
            return ["Bateria em bom estado", "Bateria precisa de teste"]
        case .brakeCheck:
            return ["Desgaste normal", "Necessita avaliação"]
        }
    }

    var relatedTutorials: [TaskType] {
        switch self {
        case .oilChange: return [.oilChange, .oilCheck]
        case .oilCheck: return [.oilCheck, .oilChange]
        default: return [self]
        }
    }

    var tutorialShortcutTitle: String {
        switch self {
        case .oilChange: return "Troca de Óleo"
        case .oilCheck: return "Verificar o Nível do Óleo"
        case .waterCheck: return "Revisão e Troca da Água do Radiador"
        case .brakeCheck: return "Verificar os Freios"
        case .tireCalibration: return "Calibrar o Pneu"
        case .batteryCheck: return "Verificar a Bateria"
        }
    }
}
