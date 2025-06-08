//
//  AuthViewModel.swift
//  ankonauto1
//
//  Created by Игорь Огай on 5/4/25.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseFirestore

class AuthViewModel {
    
    //MARK: - Properties
    
    private let authService = AuthService()
    
    //MARK: - Google Sign In
    
    func signInWithGoogle(presentingVC: UIViewController, completion: @escaping (Result<UserModel, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "Missing client ID", code: -1)))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "Missing token", code: -1)))
                return
            }
            
            let accessToken = user.accessToken.tokenString
            
            self.authService.signInWithGoogle(idToken: idToken, accessToken: accessToken) { result in
                completion(result)
            }
        }
    }
    
    func fetchUserProfile(uid: String, competion: @escaping (Result<UserModel, Error>) -> Void) {
        authService.fetchUserProfile(uid: uid, completion: competion)
    }
}
