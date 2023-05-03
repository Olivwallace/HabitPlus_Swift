//
//  SingUpViewRouter.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 27/04/23.
//

import Foundation
import SwiftUI

enum SingUpViewRouter {
    static func makeHomeView() -> some View {
        let viewModel = HomeViewModel()
        return HomeView(viewModel: viewModel)
    }
}
