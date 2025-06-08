//
//  CarService.swift
//  ankonauto1
//
//  Created by Игорь Огай on 6/8/25.
//

import Foundation
import FirebaseFirestore

class CarService {
    private let db = Firestore.firestore()
    
    func fetchBrands(completion: @escaping (Result<[CarBrand], Error>) -> Void) {
        db.collection("brands").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let brands = snapshot?.documents.compactMap { doc -> CarBrand? in
                let data = doc.data()
                guard let name = data["name"] as? String,
                      let country = data["country"] as? String,
                      let logoURL = data["logoURL"] as? String else { return nil }
                
                return CarBrand(id: doc.documentID, name: name, country: country, logoUrl: logoURL)
            } ?? []
            
            completion(.success(brands))
        }
    }
    
    func fetchModels(for brandID: String, completion: @escaping (Result<[CarModelOption], Error>) -> Void) {
        db.collection("brands").document(brandID).collection("models").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let models = snapshot?.documents.compactMap { doc -> CarModelOption? in
                let data = doc.data()
                guard let name = data["name"] as? String else { return nil }
                
                return CarModelOption(id: doc.documentID, name: name)
            } ?? []
            
            completion(.success(models))
        }
    }
    
    func fetchGenerations(for brandID: String, modelID: String, completion: @escaping (Result<[CarGeneration], Error>) -> Void) {
        db.collection("brands").document(brandID).collection("models").document(modelID).collection("generations").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let generations = snapshot?.documents.compactMap { doc -> CarGeneration? in
                let data = doc.data()
                guard let name = data["name"] as? String,
                      let startYear = data["startYear"] as? Int,
                let endYear = data["endYear"] as? Int else { return nil }
                
                return CarGeneration(id: doc.documentID, name: name, startYear: startYear, endYear: endYear)
            } ?? []
            
            completion(.success(generations))
        }
    }
}
