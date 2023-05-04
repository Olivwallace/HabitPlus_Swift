//
//  SingUpUIState.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 27/04/23.
//

import Foundation

enum SingUpUIState : Equatable {
    case none
    case loading
    case success
    case error(String)
}
