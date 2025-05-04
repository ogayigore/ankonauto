//
//  AdminTabBarController.swift
//  ankonauto1
//
//  Created by Игорь Огай on 5/4/25.
//

import UIKit

class AdminTabBarController: UITabBarController {
    
    //MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavController(for: CarsViewController(), title: "В наличии", image: UIImage(systemName: "car.fill")!),
            createNavController(for: OrdersViewController(), title: "Заказы", image: UIImage(systemName: "doc.plaintext")!),
            createNavController(for: ReviewsViewController(), title: "Отзывы", image: UIImage(systemName: "star.bubble")!),
            createNavController(for: MoreViewController(), title: "Прочее", image: UIImage(systemName: "ellipsis")!)
        ]
    }
    
    //MARK: - Methods
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.title = title
        return navController
    }
}
