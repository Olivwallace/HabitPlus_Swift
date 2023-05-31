//
//  SignInInteractor.swift
//  HabitPlus
//
//  Created by coltec on 30/05/23.
//

import Foundation
import Combine

class SignInIteractor {
    
    private let remote: SignInRemoteDataSource = .shared
    private let local: LocalDataSource = .shared
    
    func login(request: SignInRequest) -> Future<SignInResponse, AppError> {
        return remote.login(request: request)
    }
    
    func insertAuth(userAuth: UserAuth){
        local.insertUserAuth(userAuth: userAuth)
    }
    
    func fetchAuth() -> Future<UserAuth?, Never>{
        return local.getUserAuth()
    }
}
