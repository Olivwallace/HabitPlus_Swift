//
//  SignUpInteractor.swift
//  HabitPlus
//
//  Created by coltec on 30/05/23.
//

import Foundation
import Combine

class SignUpInteractor {
    
    private let remote: SignUpRemoteDataSource = .shared
    private let remoteSignIn: SignInRemoteDataSource = .shared
    private let local: LocalDataSource = .shared
    
    func postUser(request: SingUpRequest) -> Future<Bool, AppError>{
        return remote.postUser(request: request)
    }
    
    func login(request: SignInRequest) -> Future<SignInResponse, AppError>{
        return remoteSignIn.login(request: request)
    }
    
    func insertAuth(userAuth: UserAuth){
        local.insertUserAuth(userAuth: userAuth)
    }
    
}
