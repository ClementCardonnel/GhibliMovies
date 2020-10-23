//
//  BadgeSupplementaryView.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 22/10/2020.
//

import UIKit

/**
 A supplementary view that shows a little heart
 */
final class BadgeSupplementaryView: UICollectionReusableView {

    static let reuseIdentifier = "badge-reuse-identifier"
    
    private lazy var image = UIImageView(image: UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate))

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        return nil
    }
    
}



private extension BadgeSupplementaryView {
    
    func configure() {
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        
        image.layer.shadowOpacity = 0.75
        image.layer.shadowOffset = .zero
        
        addSubview(image)
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
