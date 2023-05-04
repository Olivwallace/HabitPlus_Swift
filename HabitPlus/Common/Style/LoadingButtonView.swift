//
//  LoadingButtonView.swift
//  HabitPlus
//
//  Created by coltec on 04/05/23.
//

import SwiftUI

struct LoadingButtonView: View {
    var action: () -> Void
    var text: String
    var disabled : Bool = false
    var showProgress: Bool = false
    
    var body: some View {
        ZStack {
            Button{
                action()
            }label: {
                Text(showProgress ? "" : text)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .font(Font.system(.title3).bold())
                    .background(disabled ? Color("Color_button_disabled") : Color("Color_button") )
                    .foregroundColor(.white)
                    .cornerRadius(15.0)
            }
            .disabled(disabled || showProgress)
        
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .opacity(showProgress ? 1 : 0)
        }
    }
    
    
}

struct LoadingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self){ value in
            LoadingButtonView(action: {}, text: "Entrar")
                .preferredColorScheme(value)
        }
    }
}
