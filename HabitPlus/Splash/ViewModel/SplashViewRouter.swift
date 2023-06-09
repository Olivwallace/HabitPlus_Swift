//
//  SplashVierRouter.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 13/04/23.
//

import SwiftUI
import Foundation

enum SplashViewRouter {
    static func makeHomeView() -> some View {
        let viewModel = HomeViewModel()
        return HomeView(viewModel: viewModel)
    }
    
    static func makeSingInView () -> some View {
        let viewModel = SingInViewModel(interactor: SignInIteractor())
        return SingInView(viewModel: viewModel)
    }
}
