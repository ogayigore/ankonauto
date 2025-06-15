//
//  AddPhotoCell.swift
//  ankonauto1
//
//  Created by Игорь Огай on 6/15/25.
//

import UIKit

class AddPhotoCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let icon = UIImage(systemName: "camera")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: icon)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(imageView)
        contentView.backgroundColor = .darkGray
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
