//
//  SingInViewModel.swift
//  HabitPlus
//
//  Created by Wallace Oliveira on 13/04/23.
//

import SwiftUI
import Combine
import Foundation

class SingInViewModel : ObservableObject {
    
    private var cancellable: AnyCancellable?
    private let publisher = PassthroughSubject<Bool, Never>() // Passa Mensagens
    
    @Published var email : String = ""
    @Published var password : String = ""
    
    @Published var uiState: SingInUIState = .none
    
    //--------------- Realiza esculta de mensagens
    init(){
        cancellable = publisher.sink{ value in
            if(value){
                self.uiState = .goToHomeScreen
            }
        }
    }
    
    //--------------- Finaliza esculta
    deinit{
        cancellable?.cancel()
    }
    
    
    func login(){
        
        self.uiState = .loading
        
        DispatchQueue.main.asyncAfter(deadline: .now()  + 1){
            self.uiState = .goToHomeScreen
        }
        
    }
}

extension SingInViewModel {
    func homeView() -> some View{
        return SingInViewRouter.makeHomeView()
    }
    
    func singUpView() -> some View{
        return SingInViewRouter.makeSingUpView(publisher: publisher)
    }
}
