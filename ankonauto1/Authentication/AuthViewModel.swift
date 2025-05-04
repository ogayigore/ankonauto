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
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let firebaseUser = authResult?.user else {
                    completion(.failure(NSError(domain: "Firebase user missing", code: -1)))
                    return
                }
                
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(firebaseUser.uid)
                
                userRef.getDocument { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    if let data = snapshot?.data() {
                        //Пользователь существует
                        let userModel = UserModel(uid: firebaseUser.uid,
                                                  firstName: data["firstName"] as? String,
                                                  lastName: data["lastName"] as? String,
                                                  phoneNumber: data["phoneNumber"] as? String,
                                                  email: data["email"] as? String,
                                                  isAdmin: data["isAdmin"] as? Bool ?? false)
                        completion(.success(userModel))
                    } else {
                        //Новый пользователь
                        let newUserData: [String: Any] = [
                            "uid": firebaseUser.uid,
                            "firstName": "",
                            "lastName": "",
                            "phoneNumber": firebaseUser.phoneNumber ?? "",
                            "email": firebaseUser.email ?? "",
                            "isAdmin": true
                        ]
                        
                        userRef.setData(newUserData) { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                let userModel = UserModel(uid: firebaseUser.uid,
                                                          firstName: "",
                                                          lastName: "",
                                                          phoneNumber: firebaseUser.phoneNumber,
                                                          email: firebaseUser.email,
                                                          isAdmin: true)
                                completion(.success(userModel))
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Save new user
    
    func saveUserToFirestore(user: User, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        let userData: [String: Any] = [
            "uid": user.uid,
            "email": user.email ?? "",
            "isAdmin": false,
            "firstName": "",
            "lastName": "",
            "phoneNumber": user.phoneNumber ?? ""
        ]
        
        userRef.setData(userData, merge: true, completion: completion)
    }
    
    //MARK: - Fetch user
    
    func fetchUserProfile(uid: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let docRef = Firestore.firestore().collection("users").document(uid)
        docRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = snapshot?.data() {
                let user = UserModel(uid: uid,
                                     firstName: data["firstName"] as? String,
                                     lastName: data["lastName"] as? String,
                                     phoneNumber: data["phoneNumber"] as? String,
                                     email: data["email"] as? String,
                                     isAdmin: data["isAdmin"] as? Bool ?? false)
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пользователь не найден"])))
            }
        }
    }
}
