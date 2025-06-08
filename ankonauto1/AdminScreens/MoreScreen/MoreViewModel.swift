//
//  MoreViewModel.swift
//  ankonauto1
//
//  Created by Игорь Огай on 6/8/25.
//

import UIKit

class MoreViewModel {
    
    //MARK: - Properties
    
    private let authService: AuthService
    
    //MARK: - Initialization
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }
    
    //MARK: - SignOut
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        authService.signOut(completion: completion)
    }
}
