//
//  SingUpViewModel.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 25/04/23.
//

import SwiftUI
import Combine
import Foundation

class SingUpViewModel : ObservableObject {
    
    var publisher: PassthroughSubject<Bool, Never>! //Obrigatório
    
    @Published var uiState: SingUpUIState = .none
    
    func singUp (){
        self.uiState = .loading
        
        DispatchQueue.main.asyncAfter(deadline: .now()  + 1){
            self.uiState = .success
            self.publisher.send(true) //Responde via publisher que pode alterar estado.
        }
        
    }
    
}

extension SingUpViewModel {
    func homeView() -> some View {
        return SingUpViewRouter.makeHomeView()
    }
}
