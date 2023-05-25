//
//  SignInResponse.swift
//  HabitPlus
//
//  Created by coltec on 25/05/23.
//

import Foundation

struct SignInResponse: Decodable {
    
    let accessToken: String
    let refreshToken: String
    let expires: Int
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expires
        case tokenType = "token_type"
    }
}


struct SignInErrorResponse: Decodable {
    let detail: SignInDetailErrorResponse
    
    enum CodingKeys: String, CodingKey {
        case detail
    }

}


struct SignInDetailErrorResponse: Decodable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
    
}
