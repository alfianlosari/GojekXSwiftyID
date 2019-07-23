//
//  PetThumbnailCollectionViewCell.swift
//  PetsDiffingiOS13
//
//  Created by Alfian Losari on 18/07/19.
//  Copyright © 2019 alfianlosari. All rights reserved.
//

import UIKit

class PetThumbnailCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.layer.cornerRadius = 8
        contentView.layer.cornerRadius = 8
        
    }
    
    private func setupLayout() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
    
        self.imageView = imageView
        
    }
    
    func configure(_ image: UIImage) {
   
        imageView?.image = image
    }
    
    
}
