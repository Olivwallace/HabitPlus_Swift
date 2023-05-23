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
        WebService.postUser(request: SingUpRequest(fullName: fullName,
                            email: email,
                            password: password,
                            document: document,
                            phone: phone,
                            birthday: birthday,
                            gender: gender.index)){(successResp, errorResp) in
            
            // Case Error
            if let error = errorResp {
                DispatchQueue.main.async {
                    self.uiState = .error(error.detail)
                }
            }
            
            //Case Sucess
            if let success = successResp {
                DispatchQueue.main.async {
                    if success{
                        self.uiState = .success
                        self.publisher.send(success)
                    }
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
