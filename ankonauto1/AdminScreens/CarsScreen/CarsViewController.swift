//
//  CarsViewController.swift
//  ankonauto1
//
//  Created by Игорь Огай on 5/4/25.
//

import UIKit

class CarsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let authViewModel: AuthViewModel
    private let currentUser: UserModel
    
    var cars: [CarModel] = []
    
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
    
    //MARK: - UI Elements
    
    lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: view.frame.width / 2 - 20, height: 200)
        layout.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CarCell.self, forCellWithReuseIdentifier: "CarCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: - Methods
    
    func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension CarsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarCell", for: indexPath) as! CarCell
        let car = cars[indexPath.row]
        cell.configure(with: car)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let car = cars[indexPath.row]
        print("Выбран - \(car.brand) \(car.model)")
    }
}
