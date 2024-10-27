//
//  GeneralCharacterCWCell.swift
//  Rick&Morty
//
//  Created by Ravan on 24.10.24.
//

import Foundation
import UIKit
import SDWebImage

class GeneralCharacterCWCell: UICollectionViewCell {
    
    static let identifier = "GeneralCharacterCWCell"
    
    lazy var nameTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var statusTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var statusColorDot: UIView = {
        let dot = UIView()
        dot.backgroundColor = .yellow
        dot.clipsToBounds = true
        dot.layer.cornerRadius = 16
        dot.translatesAutoresizingMaskIntoConstraints = false
        return dot
    }()
    
    lazy var statusStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [statusColorDot, statusTitle])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 2
        return stack
    }()
    
    
    lazy var nameStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameTitle, statusStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 2
        return stack
    }()
    
    lazy var lastKnownLocationTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Last known location:"
        label.textColor = .black
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var lastKnownLocationDataTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Purge Planet"
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var locationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lastKnownLocationTitle, lastKnownLocationDataTitle])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 2
        return stack
    }()
    
    lazy var firstSeenTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "First seen in:"
        label.textColor = .black
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var firstSeenDataTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var seenStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstSeenTitle, firstSeenDataTitle])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 2
        return stack
    }()
    
    lazy var labelStacks: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameStack, locationStack, seenStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 4
        return stack
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo.artframe")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /*lazy var viewStacks: UIStackView = {
     let stack = UIStackView(arrangedSubviews: [imageView, labelStacks])
     stack.translatesAutoresizingMaskIntoConstraints = false
     stack.axis = .horizontal
     stack.alignment = .center
     stack.distribution = .fillEqually
     stack.spacing = 16
     return stack
     }()*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        contentView.addSubview(imageView)
        contentView.addSubview(labelStacks)
        
        NSLayoutConstraint.activate([
            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 180),
            imageView.widthAnchor.constraint(equalToConstant: 180),
            
            labelStacks.topAnchor.constraint(equalTo: contentView.topAnchor),
            labelStacks.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            labelStacks.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            labelStacks.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            statusColorDot.widthAnchor.constraint(equalToConstant: 8),
            statusColorDot.heightAnchor.constraint(equalToConstant: 8)
            
        ])
    }
    
    func configure(with model: SearchModel) {
        
        nameTitle.text = model.name
        statusTitle.text = model.status + " - " + model.species
        lastKnownLocationDataTitle.text = model.location.name
        firstSeenDataTitle.text = model.origin.name
        
        if let url = URL(string: model.image) {
            imageView.sd_setImage(with: url, completed: nil)
        }
        
        if model.status == "Alive" {
            statusColorDot.backgroundColor = .green
        } else if model.status == "Dead" {
            statusColorDot.backgroundColor = .red
        } else { statusColorDot.backgroundColor = .gray }
        
    }
    
    /*  func setDotColor() {
     
     if statusTitle.text == "Alive" {
     statusColorDot.backgroundColor = .green
     } else if statusTitle.text == "Dead" {
     statusColorDot.backgroundColor = .red
     } else { statusColorDot.backgroundColor = .gray }
     
     } */
    
}
