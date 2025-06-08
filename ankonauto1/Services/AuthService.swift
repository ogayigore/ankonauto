//
//  AuthService.swift
//  ankonauto1
//
//  Created by Игорь Огай on 6/4/25.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

final class AuthService {
    //MARK: - Google Sign In
    
    func signInWithGoogle(idToken: String, accessToken: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
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
                    let userModel = UserModel(uid: firebaseUser.uid, firstName: data["firstName"] as? String, lastName: data["lastName"] as? String, phoneNumber: data["phoneNumber"] as? String, email: data["email"] as? String, isAdmin: data["isAdmin"] as? Bool ?? false)
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
    
    //MARK: - Save new user
    
    func saveUser(userModel: UserModel, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userModel.uid)
        
        let userData: [String: Any] = [
            "uid": userModel.uid,
            "email": userModel.email ?? "",
            "isAdmin": false,
            "firstName": "",
            "lastName": "",
            "phoneNumber": userModel.phoneNumber ?? ""
        ]
        
        userRef.setData(userData, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(userModel))
            }
        }
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
    
    //MARK: - Sign Out
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        let firebaseAuth = Auth.auth()
        
        do {
            //Google Sign Out
            GIDSignIn.sharedInstance.signOut()
            
            //Firebase Sign Out
            try firebaseAuth.signOut()
            
            completion(.success(()))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }
}
