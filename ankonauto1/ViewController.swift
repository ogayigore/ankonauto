//
//  AuthViewController.swift
//  ankonauto1
//
//  Created by Игорь Огай on 5/3/25.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class AuthViewController: UIViewController {

    //MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        googleButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
    }
    
    //MARK: - Methods
    
    //Вход с Google
    @objc func signInWithGoogle() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        //Настройка конфигурации GoogleSignIn
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            if let error = error {
                print("Google Sign-In error \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else { return }
            print("User email: \(user.profile?.email ?? "No email")")
            
            guard let idToken = user.idToken?.tokenString else { return }
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            //Авторизация в firebase
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Sign-In error: \(error.localizedDescription)")
                    return
                }
                
                print("User signed in with Google: \(authResult?.user.displayName ?? "No name")")
                self.goToHomeViewController()
            }
        }
    }
    
    //Переход на главный экран
    func goToHomeViewController() {
        
    }
    
    //MARK: - Setup UI
    lazy var phoneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вход по номеру телефона", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont(name: "SFProDisplay", size: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var googleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вход через Google", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont(name: "SFProDisplay", size: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setUpUI() {
        
        view.addSubview(phoneButton)
        view.addSubview(googleButton)
        
        NSLayoutConstraint.activate([
            phoneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            phoneButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            phoneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            phoneButton.heightAnchor.constraint(equalToConstant: 50),
            googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleButton.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: 8),
            googleButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            googleButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            googleButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

