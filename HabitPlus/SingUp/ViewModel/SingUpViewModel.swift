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
    
    
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var document = ""
    @Published var phone = ""
    @Published var birthday = ""
    @Published var gender = Gender.female
    
    @Published var uiState: SingUpUIState = .none
    
    private let interactor: SignUpInteractor
    private var cancellableSignUp: AnyCancellable?
    private var cancellableSignIn: AnyCancellable?
    
    init(interactor: SignUpInteractor){
        self.interactor = interactor
    }
    
    deinit{
        cancellableSignUp?.cancel()
        cancellableSignIn?.cancel()
    }
    
    
    func singUp (){
        self.uiState = .loading
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy"

        let dateFormatted = formatter.date(from: birthday)

        guard let dateFormatted = dateFormatted else {
            self.uiState = .error("Data Invalida\(birthday)")
            return
        }
        
        formatter.dateFormat = "yyyy-MM-dd"
        let birthday = formatter.string(from: dateFormatted)
        
        
        // Realiza chamada da API para realizar SingUp
        cancellableSignUp = interactor.postUser(request: SingUpRequest(fullName: fullName,
                                                        email: email,
                                                        password: password,
                                                        document: document,
                                                        phone: phone,
                                                        birthday: birthday,
                                                        gender: gender.index))
        .receive(on: DispatchQueue.main)
        .sink{ completion in
            
            switch(completion){
                case .failure(let appError):
                    self.uiState = .error(appError.message)
                    break
                case .finished:
                    break
            }
    
        } receiveValue: { created in
                
            if (created){
                self.cancellableSignIn = self.interactor.login(request: SignInRequest(email: self.email,
                                                                                      password: self.password))
                .receive(on: DispatchQueue.main)
                .sink{ completion in
                    
                    switch (completion){
                        case .failure(let appError):
                            self.uiState = .error(appError.message)
                            break
                        case .finished:
                            break
                    }
                    
                } receiveValue: { sucessSignIn in
                    print(created)
                    self.publisher.send(created)
                    self.uiState = .success
                }
            }
            
        } // End WebService.postUser
        
        
    }
}

extension SingUpViewModel {
    func homeView() -> some View {
        return SingUpViewRouter.makeHomeView()
    }
}
