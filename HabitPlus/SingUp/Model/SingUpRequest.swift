//
//  SingUpRequest.swift
//  HabitPlus
//
//  Created by coltec on 18/05/23.
//

import Foundation

struct SingUpRequest: Encodable{
    
    let fullName: String
    let email: String
    let password: String
    let document: String
    let phone: String
    let birthday: String
    let gender: Int
    
    enum CodingKeys: String, CodingKey {
        case fullName = "name"
        case email
        case password
        case document
        case phone
        case birthday
        case gender
    }
}
