//
//  CarModel.swift
//  ankonauto1
//
//  Created by Игорь Огай on 5/12/25.
//

import Foundation

struct CarModel: Codable {
    let id: String
    let brand: String
    let model: String
    let dateOfManufacture: String
    let mileage: Int
    let fuelType: String
    let transmission: String
    let driveType: String
    let engineCapacity: Double
    let enginePower: Int
    let equipment: String
    let color: String
    let images: [String]
    let dateAdded: String
    let price: Int
}
