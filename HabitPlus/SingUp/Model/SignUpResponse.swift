//
//  SignUpResponse.swift
//  HabitPlus
//
//  Created by coltec on 23/05/23.
//

import Foundation
import SwiftUI

struct SignUpResponse: Decodable{
    
    let detail: String?
    
    enum CodingKeys: String, CodingKey {
        case detail
    }
    
}
