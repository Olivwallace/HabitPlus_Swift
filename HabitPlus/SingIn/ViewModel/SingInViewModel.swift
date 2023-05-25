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
        
        WebService.login(request: SignInRequest(email: email, password: password)){
            (sucessResponse, errorResponse) in
            
            // Case Error
            if let error = errorResponse {
                DispatchQueue.main.async{
                    self.uiState = .error(error.detail.message)
                }
            }
            
            // Case Success
            if let success = sucessResponse {
                DispatchQueue.main.async {
                    print(success)
                    self.uiState = .goToHomeScreen
                }
            }
            
        }
        
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
