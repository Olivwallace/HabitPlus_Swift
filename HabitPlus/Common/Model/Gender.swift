//
//  Gender.swift
//  HabitPlus
//
//  Created by coltec on 27/04/23.
//

import Foundation

enum Gender: String, CaseIterable, Identifiable {
    
    case female = "Feminino"
    case male = "Masculino"
    case other = "Outro"
    case notInformed = "Não Informado"
    
    var id: String {
        self.rawValue
    }
}
