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
    private var cancellableRequest: AnyCancellable?
    private let publisher = PassthroughSubject<Bool, Never>() // Passa Mensagens
    
    private let interactor: SignInIteractor
    
    @Published var email : String = ""
    @Published var password : String = ""
    
    @Published var uiState: SingInUIState = .none
    
    //--------------- Realiza esculta de mensagens
    init(interactor: SignInIteractor){
        self.interactor = interactor
        
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
        
        cancellableRequest = interactor.login(request: SignInRequest(email: email, password: password))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                
                switch(completion){
                    case .failure(let appError):
                        self.uiState = SingInUIState.error(appError.message)
                        break
                    case .finished:
                        break
                }
                
            } receiveValue: { sucess in
                print(sucess)
                self.interactor.insertAuth(userAuth: UserAuth(idToken: sucess.accessToken,
                                                              refreshToken: sucess.refreshToken,
                                                              expires: Date().timeIntervalSince1970 + Double(sucess.expires),
                                                              tokenType: sucess.tokenType))
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
