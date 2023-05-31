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
    
    private var cancellableAuth: AnyCancellable?
    private let interactor: SplashInteractor
    

    init(interactor: SplashInteractor){
        self.interactor = interactor
    }
    
    deinit{
        cancellableAuth?.cancel()
    }
    
    func onAppear() {
        
        cancellableAuth = interactor.fetchAuth()
            .receive(on: DispatchQueue.main)
            .sink{
                userAuth in
                
                if userAuth == nil{
                    self.uiState = .goToSingInScreen
                } else if( Date().timeIntervalSince1970 > Double(userAuth!.expires)){
                    self.cancellableAuth = self.interactor.refreshToken(request: RefreshRequest(token: userAuth!.refreshToken))
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: {
                            completion in
                            
                            switch completion{
                                case .failure(_):
                                    self.uiState = .goToSingInScreen
                                    break
                                default:
                                    break
                            }
                        }, receiveValue: { success in
                            
                            let auth = UserAuth(idToken: success.accessToken, refreshToken: success.refreshToken, expires: Date().timeIntervalSince1970 + Double(success.expires), tokenType: success.tokenType)
                            
                            self.interactor.insertAuth(userAuth: auth)
                            self.uiState = .goToHomeScreen
                            
                        }
                        )
                        
                } else {
                    self.uiState = .goToHomeScreen
                }
                
            }

    }
}

extension SplashViewModel {
    func homeView() -> some View{
        return SingUpViewRouter.makeHomeView()
    }
    func singInView () -> some View {
        return SplashViewRouter.makeSingInView()
    }
}

