//
//  ReviewsViewController.swift
//  ankonauto1
//
//  Created by Игорь Огай on 5/4/25.
//

import UIKit

class ReviewsViewController: UIViewController {
    
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
        
    }
}
