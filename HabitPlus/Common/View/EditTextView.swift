//
//  EditTextView.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 02/05/23.
//

import SwiftUI

struct EditTextView: View {
    
    
    var placeholder: String = ""
    @Binding var text: String
    
    var error: String? = nil
    var failure: Bool? = nil
    var isSecure: Bool = false
    
    var keyboard: UIKeyboardType = .default
    
    var body: some View {
        VStack{
            if isSecure{
                SecureField(placeholder, text: $text)
                    .keyboardType(keyboard)
                    .textFieldStyle(CustomTextFieldStyle())

            }else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboard)
                    .textFieldStyle(CustomTextFieldStyle())
                    .textInputAutocapitalization(.never)
            }
            
            if let error = error, failure == true, !text.isEmpty{
                Text(error).foregroundColor(.red)
            }
        }
    }
}

struct EditTextView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self){ value in
            EditTextView(placeholder: "E-mail", text: .constant("E-mail"), keyboard: .default)
                .preferredColorScheme(value)
        }
    }
}
