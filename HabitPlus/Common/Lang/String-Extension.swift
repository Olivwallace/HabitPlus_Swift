//
//  String-Extension.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 02/05/23.
//

import Foundation

extension String{
    func isEmail() -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regEx).evaluate(with: self)
    }
   
}
