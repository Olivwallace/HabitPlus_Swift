//
//  SplashVierRouter.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 13/04/23.
//

import SwiftUI
import Foundation

enum SplashViewRouter {
    static func makeSingInView () -> some View {
        let viewModel = SingInViewModel()
        return SingInView(viewModel: viewModel)
    }
}
