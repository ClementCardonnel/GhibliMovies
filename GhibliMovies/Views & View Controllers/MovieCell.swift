//
//  MovieCell.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 21/10/2020.
//

import UIKit

final class MovieCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let reuseIdentifier = "movie-cell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        return imageView
    }()
    
    /// Will show the title of the film
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        return label
    }()
    
    /// Will show the film's release date
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var textBackground: UIVisualEffectView = {
        let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    // Update appearance upon selection by the user
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .secondarySystemBackground
            } else {
                backgroundColor = .systemBackground
            }
        }
    }
    
    
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        contentView.addSubview(imageView)
        contentView.addSubview(textBackground)
        textBackground.contentView.addSubview(titleLabel)
        textBackground.contentView.addSubview(releaseDateLabel)
                
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: textBackground.contentView.topAnchor, constant: Constants.textVerticalMargin),
            titleLabel.bottomAnchor.constraint(equalTo: releaseDateLabel.topAnchor, constant: -Constants.interLabelSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: textBackground.contentView.leadingAnchor, constant: Constants.textSideMargin),
            titleLabel.centerXAnchor.constraint(equalTo: textBackground.contentView.centerXAnchor),
            
            releaseDateLabel.bottomAnchor.constraint(equalTo: textBackground.contentView.bottomAnchor, constant: -Constants.textVerticalMargin),
            releaseDateLabel.leadingAnchor.constraint(equalTo: textBackground.contentView.leadingAnchor, constant: Constants.textSideMargin),
            releaseDateLabel.centerXAnchor.constraint(equalTo: textBackground.contentView.centerXAnchor),
            
            textBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        releaseDateLabel.text = nil
        imageView.image = nil
    }
    
    
    
    func present(_ film: Film) {
        titleLabel.text = film.title
        releaseDateLabel.text = "\(film.releaseDate)"
        imageView.image = film.cover
    }
    
}


// MARK: - Constants

private extension MovieCell {
    
    struct Constants {
        static let cornerRadius: CGFloat = 10
        
        static let textVerticalMargin: CGFloat = 8
        static let textSideMargin: CGFloat = 8
        static let interLabelSpacing: CGFloat = 4
        static let textToImageSpacing: CGFloat = 8
    }

}


