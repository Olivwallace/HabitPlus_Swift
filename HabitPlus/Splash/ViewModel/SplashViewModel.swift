//
//  SplashViewModel.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 13/04/23.
//

import Combine
import SwiftUI
import Foundation


class SplashViewModel : ObservableObject {
    
    @Published var uiState: SplashUIState = .loading //Obsevavel de estado 

    func onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.uiState = .goToSingInScreen
        }
    }
    
    func singInView () -> some View {
        return SplashViewRouter.makeSingInView()
    }
    
}

