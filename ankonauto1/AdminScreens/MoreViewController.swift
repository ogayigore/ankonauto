//
//  MoreViewController.swift
//  ankonauto1
//
//  Created by Игорь Огай on 5/4/25.
//

import UIKit

class MoreViewController: UIViewController {
    
    //MARK: - Properties
    
    private let authViewModel: AuthViewModel
    private let currentUser: UserModel
    
    //MARK: - Initializers
    
    init(authViewModel: AuthViewModel, currentUser: UserModel) {
        self.authViewModel = authViewModel
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Methods
    
    func setupUI() {
        let signOutButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Выйти", for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 12
            button.titleLabel?.font = UIFont(name: "SFProDisplay", size: 12)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(signOutButton)
        
        NSLayoutConstraint.activate([
            signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signOutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            signOutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            signOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func signOut() {
        authViewModel.signOut { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    let authVC = AuthViewController(viewModel: self!.authViewModel)
                    authVC.modalPresentationStyle = .fullScreen
                    self?.present(authVC, animated: true)
                }
            case .failure(let error):
                print("Ошибка выхода: \(error.localizedDescription)")
            }
        }
    }
}
