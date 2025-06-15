//
//  NewCarViewModel.swift
//  ankonauto1
//
//  Created by Игорь Огай on 6/8/25.
//

import Foundation
import FirebaseFirestore

final class NewCarViewModel {
    //MARK: - Properties
    
    private let carService: CarService
    private let db = Firestore.firestore()
    
    var brands: [CarBrand] = []
    var models: [CarModelOption] = []
    var generations: [CarGeneration] = []
    
    var onDataUpdated: (() -> Void)?
    
    //MARK: - Initialization
    
    init(carService: CarService = CarService()) {
        self.carService = carService
    }
    
    //MARK: - Methods
    
    func fetchBrands(completion: @escaping (Result<[CarBrand], Error>) -> Void) {
        carService.fetchBrands { result in
            switch result {
            case .success(let brands):
                self.brands = brands
                completion(.success(brands))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchModels(for brandID: String) {
        carService.fetchModels(for: brandID) { result in
            switch result {
            case .success(let models):
                self.models = models
                self.onDataUpdated?()
            case .failure(let error):
                print("Ошибка загрузка моделей \(error.localizedDescription)")
            }
        }
    }
    
    func fetchGenerations(for brandID: String, modelID: String) {
        carService.fetchGenerations(for: brandID, modelID: modelID) { result in
            switch result {
            case .success(let generations):
                print("Поколение: \(generations.map { $0.name })")
                self.generations = generations
                self.onDataUpdated?()
            case .failure(let error):
                print("Ошибка загрузка поколений \(error.localizedDescription)")
            }
        }
    }
}
