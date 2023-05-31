//
//  SingInVierRouter.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 25/04/23.
//

import SwiftUI
import Combine
import Foundation

enum SingInViewRouter {
    static func makeHomeView() -> some View {
        let viewModel = HomeViewModel()
        return HomeView(viewModel: viewModel)
    }
    
    static func makeSingUpView(publisher: PassthroughSubject<Bool, Never>) -> some View {
        let viewModel = SingUpViewModel(interactor: SignUpInteractor())
        viewModel.publisher = publisher
        return SingUpView(viewModel: viewModel)
    }
}
