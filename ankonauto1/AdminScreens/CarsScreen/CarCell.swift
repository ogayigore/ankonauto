//
//  CarCell.swift
//  ankonauto1
//
//  Created by Игорь Огай on 5/12/25.
//

import UIKit

class CarCell: UICollectionViewCell {
    
    //MARK: - UI Elements
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let equipmentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let engineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let transmissionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let driveTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mileageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateOfManufactureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(equipmentLabel)
//        contentView.addSubview(engineLabel)
//        contentView.addSubview(transmissionLabel)
//        contentView.addSubview(driveTypeLabel)
        contentView.addSubview(mileageLabel)
        contentView.addSubview(dateOfManufactureLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            priceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2),
            priceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            equipmentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            equipmentLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2),
            equipmentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
//            engineLabel.topAnchor.constraint(equalTo: equipmentLabel.bottomAnchor, constant: 8),
//            engineLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            engineLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
//            
//            transmissionLabel.topAnchor.constraint(equalTo: engineLabel.bottomAnchor, constant: 8),
//            transmissionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            transmissionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
//            
//            driveTypeLabel.topAnchor.constraint(equalTo: transmissionLabel.bottomAnchor, constant: 8),
//            driveTypeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            driveTypeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            mileageLabel.topAnchor.constraint(equalTo: equipmentLabel.bottomAnchor, constant: 2),
            mileageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2),
            mileageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            dateOfManufactureLabel.topAnchor.constraint(equalTo: mileageLabel.bottomAnchor, constant: 2),
            dateOfManufactureLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2),
            dateOfManufactureLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            dateOfManufactureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func configure(with car: CarModel) {
        imageView.image = UIImage(named: car.images.first ?? "")
        priceLabel.text = "\(car.price.formattedPrice)₽"
        titleLabel.text = "\(car.brand) \(car.model)"
        equipmentLabel.text = "\(car.equipment)"
        engineLabel.text = "\(car.engineCapacity)литра \(car.fuelType) \(car.enginePower)л.с."
        transmissionLabel.text = "\(car.transmission)"
        driveTypeLabel.text = "\(car.driveType) привод"
        mileageLabel.text = "\(car.mileage) км"
        dateOfManufactureLabel.text = "\(car.dateOfManufacture)"
    }
}

extension Int {
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
