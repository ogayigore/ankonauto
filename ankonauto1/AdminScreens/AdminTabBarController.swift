//
//  AdminTabBarController.swift
//  ankonauto1
//
//  Created by Игорь Огай on 5/4/25.
//

import UIKit

class AdminTabBarController: UITabBarController {
    
    //MARK: - Properties
    
    private let authViewModel: AuthViewModel
    private let currentUser: UserModel
    
    //MARK: - Initializers
    
    init(authViewModel: AuthViewModel, currentUser: UserModel) {
        self.authViewModel = authViewModel
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        setupTabs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Methods
    
    private func setupTabs() {
        let carsVC = CarsViewController(authViewModel: authViewModel, currentUser: currentUser)
        let ordersVC = OrdersViewController(authViewModel: authViewModel, currentUser: currentUser)
        let reviewsVC = ReviewsViewController(authViewModel: authViewModel, currentUser: currentUser)
        let moreVC = MoreViewController(authViewModel: authViewModel, currentUser: currentUser)
        
        viewControllers = [
            createNavController(for: carsVC, title: "Каталог", image: UIImage(systemName: "car.fill")!),
            createNavController(for: ordersVC, title: "Заказы", image: UIImage(systemName: "doc.plaintext")!),
            createNavController(for: reviewsVC, title: "Отзывы", image: UIImage(systemName: "star.bubble")!),
            createNavController(for: moreVC, title: "Прочее", image: UIImage(systemName: "ellipsis")!)
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.title = title
        return navController
    }
}
