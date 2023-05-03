//
//  CustomTextFieldStyle.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 02/05/23.
//

import Foundation
import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View{
        configuration
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color.cyan, lineWidth: 0.9)
            )
    }
}
