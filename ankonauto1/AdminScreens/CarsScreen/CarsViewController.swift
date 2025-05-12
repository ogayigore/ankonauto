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
        
        setupUI()
        loadCars()
    }
    
    //MARK: - UI Elements
    
    lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
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
    
    func loadCars() {
        cars = [
            CarModel(id: "1",
                     brand: "BMW",
                     model: "3-Серия",
                     dateOfManufacture: "12-2020",
                     mileage: 107580,
                     fuelType: "Бензин",
                     transmission: "Автомат",
                     driveType: "Задний",
                     engineCapacity: 2998,
                     enginePower: 387,
                     equipment: "М340i",
                     color: "Чёрный",
                     images: ["bmw"],
                     dateAdded: "12.05.2025",
                     price: 5000000),
            CarModel(id: "2",
                     brand: "Mercedes-Benz",
                     model: "C-класс",
                     dateOfManufacture: "12-2022",
                     mileage: 11915,
                     fuelType: "Бензин",
                     transmission: "Автомат",
                     driveType: "Полный",
                     engineCapacity: 1999,
                     enginePower: 258,
                     equipment: "C300 4MATIC AMG Line",
                     color: "Белый",
                     images: ["benz"],
                     dateAdded: "12.05.2025", price: 6000000),
            CarModel(id: "1",
                     brand: "BMW",
                     model: "3-Серия",
                     dateOfManufacture: "12-2020",
                     mileage: 107580,
                     fuelType: "Бензин",
                     transmission: "Автомат",
                     driveType: "Задний",
                     engineCapacity: 2998,
                     enginePower: 387,
                     equipment: "М340i",
                     color: "Чёрный",
                     images: ["bmw"],
                     dateAdded: "12.05.2025",
                     price: 5000000),
            CarModel(id: "2",
                     brand: "Mercedes-Benz",
                     model: "C-класс",
                     dateOfManufacture: "12-2022",
                     mileage: 11915,
                     fuelType: "Бензин",
                     transmission: "Автомат",
                     driveType: "Полный",
                     engineCapacity: 1999,
                     enginePower: 258,
                     equipment: "C300 4MATIC AMG Line",
                     color: "Белый",
                     images: ["benz"],
                     dateAdded: "12.05.2025", price: 6000000),
            CarModel(id: "1",
                     brand: "BMW",
                     model: "3-Серия",
                     dateOfManufacture: "12-2020",
                     mileage: 107580,
                     fuelType: "Бензин",
                     transmission: "Автомат",
                     driveType: "Задний",
                     engineCapacity: 2998,
                     enginePower: 387,
                     equipment: "М340i",
                     color: "Чёрный",
                     images: ["bmw"],
                     dateAdded: "12.05.2025",
                     price: 5000000),
            CarModel(id: "2",
                     brand: "Mercedes-Benz",
                     model: "C-класс",
                     dateOfManufacture: "12-2022",
                     mileage: 11915,
                     fuelType: "Бензин",
                     transmission: "Автомат",
                     driveType: "Полный",
                     engineCapacity: 1999,
                     enginePower: 258,
                     equipment: "C300 4MATIC AMG Line",
                     color: "Белый",
                     images: ["benz"],
                     dateAdded: "12.05.2025", price: 6000000),
            CarModel(id: "1",
                     brand: "BMW",
                     model: "3-Серия",
                     dateOfManufacture: "12-2020",
                     mileage: 107580,
                     fuelType: "Бензин",
                     transmission: "Автомат",
                     driveType: "Задний",
                     engineCapacity: 2998,
                     enginePower: 387,
                     equipment: "М340i",
                     color: "Чёрный",
                     images: ["bmw"],
                     dateAdded: "12.05.2025",
                     price: 5000000),
            CarModel(id: "2",
                     brand: "Mercedes-Benz",
                     model: "C-класс",
                     dateOfManufacture: "12-2022",
                     mileage: 11915,
                     fuelType: "Бензин",
                     transmission: "Автомат",
                     driveType: "Полный",
                     engineCapacity: 1999,
                     enginePower: 258,
                     equipment: "C300 4MATIC AMG Line",
                     color: "Белый",
                     images: ["benz"],
                     dateAdded: "12.05.2025", price: 6000000),
            CarModel(id: "1",
                     brand: "BMW",
                     model: "3-Серия",
                     dateOfManufacture: "12-2020",
                     mileage: 107580,
                     fuelType: "Бензин",
                     transmission: "Автомат",
                     driveType: "Задний",
                     engineCapacity: 2998,
                     enginePower: 387,
                     equipment: "М340i",
                     color: "Чёрный",
                     images: ["bmw"],
                     dateAdded: "12.05.2025",
                     price: 5000000),
            CarModel(id: "2",
                     brand: "Mercedes-Benz",
                     model: "C-класс",
                     dateOfManufacture: "12-2022",
                     mileage: 11915,
                     fuelType: "Бензин",
                     transmission: "Автомат",
                     driveType: "Полный",
                     engineCapacity: 1999,
                     enginePower: 258,
                     equipment: "C300 4MATIC AMG Line",
                     color: "Белый",
                     images: ["benz"],
                     dateAdded: "12.05.2025", price: 6000000),
            CarModel(id: "1",
                     brand: "BMW",
                     model: "3-Серия",
                     dateOfManufacture: "12-2020",
                     mileage: 107580,
                     fuelType: "Бензин",
                     transmission: "Автомат",
                     driveType: "Задний",
                     engineCapacity: 2998,
                     enginePower: 387,
                     equipment: "М340i",
                     color: "Чёрный",
                     images: ["bmw"],
                     dateAdded: "12.05.2025",
                     price: 5000000),
            CarModel(id: "2",
                     brand: "Mercedes-Benz",
                     model: "C-класс",
                     dateOfManufacture: "12-2022",
                     mileage: 11915,
                     fuelType: "Бензин",
                     transmission: "Автомат",
                     driveType: "Полный",
                     engineCapacity: 1999,
                     enginePower: 258,
                     equipment: "C300 4MATIC AMG Line",
                     color: "Белый",
                     images: ["benz"],
                     dateAdded: "12.05.2025", price: 6000000),
        ]
        collectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let car = cars[indexPath.row]
        print("Выбран - \(car.brand) \(car.model)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let padding: CGFloat = 16
        let spacing: CGFloat = 16
        
        let totalSpacing = padding * 2 + spacing * (numberOfItemsPerRow - 1)
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        
        return CGSize(width: itemWidth, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
    }
}
