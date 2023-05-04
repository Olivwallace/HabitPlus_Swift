//
//  SingInModel.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 13/04/23.
//

import Foundation

enum SingInUIState : Equatable {
    case none
    case loading
    case goToHomeScreen
    case error(String)
}
