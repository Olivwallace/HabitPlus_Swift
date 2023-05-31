//
//  SplashInteractor.swift
//  HabitPlus
//
//  Created by coltec on 30/05/23.
//

import Foundation
import Combine

class SplashInteractor {
    
    private let local: LocalDataSource = .shared
    private let remote: SplashRemoteDataSource = .shared

    
    func fetchAuth() -> Future<UserAuth?, Never>{
        return local.getUserAuth()
    }
    
    func refreshToken(request: RefreshRequest) -> Future<SignInResponse, AppError>{
        return remote.refreshToken(request: request)
    }
    
    func insertAuth(userAuth: UserAuth){
        local.insertUserAuth(userAuth: userAuth)
    }
    
  
}
