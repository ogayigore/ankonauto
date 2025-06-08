//
//  CarField.swift
//  ankonauto1
//
//  Created by Игорь Огай on 6/1/25.
//

import Foundation
import UIKit

enum CarField: String, CaseIterable {
    case brand = "Марка"
    case model = "Модель"
    case generation = "Поколение"
    case dateOfManufacture = "Год выпуска"
    case mileage = "Пробег"
    case fuelType = "Тип двигателя"
    case transmisson = "Коробка передач"
    case driveType = "Привод"
    case engineCapacity = "Объем двигателя"
    case enginePower = "Мощность двигателя"
    case equipment = "Комплектация"
    case color = "Цвет"
    case price = "Цена"
    
    var isSelectable: Bool {
        return self == .brand || self == .model || self == .generation
    }
    
    var options: [String]? {
        switch self {
        case .fuelType:
            return ["Бензин", "Дизель", "Гибрид", "Электро"]
        case .transmisson:
            return ["Механика", "Автомат", "Робот", "Вариатор"]
        case .driveType:
            return ["Передний", "Задний", "Полный"]
        default:
            return nil
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .mileage, .engineCapacity, .enginePower, .price:
            return .decimalPad
        default:
            return .default
        }
    }
}
