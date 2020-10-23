//
//  DetailViewController.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 22/10/2020.
//

import UIKit
import Combine

/**
 The view controller that shows the details of a Film
 */
class DetailViewController: UIViewController {
    
    // MARK: Public Properties
    
    var film: Film? {
        didSet {
            guard isViewLoaded else { return }
            
            if let film = film {
                updateUI(with: film)
            }
        }
    }
    
    /// This handler will be called when the user taps the favorite button of this view controller
    var onFavoriteToggleHandler: FilmHandler?
    
    // MARK: Private Properties
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.isHidden = true
        }
    }
    
    @IBOutlet private weak var coverImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var releaseDateLabel: UILabel!
    
    @IBOutlet private weak var synopsisLabel: UILabel!
    
    @IBOutlet private weak var producerLabel: UILabel!
    
    @IBOutlet private weak var directorLabel: UILabel!
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var favoriteButton = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(onFavoriteButtonTap))
    
    
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = favoriteButton
        
        if let film = film {
            updateUI(with: film)
        }
    }
    
    private func updateUI(with film: Film) {
        scrollView.isHidden = false
        
        title = film.title
        
        backgroundImageView.image = film.cover?.blurred()
        coverImageView.image = film.cover
        titleLabel.text = film.title
        releaseDateLabel.text = "\(film.releaseDate)"
        synopsisLabel.text = film.description
        producerLabel.text = film.producer
        directorLabel.text = film.director
        
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        guard let film = film else {
            return
        }
        
        if film.isFavorite {
            favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteButton.image = UIImage(systemName: "heart")
        }
    }
    
    
    
    // MARK: User Interaction
    
    @objc private func onFavoriteButtonTap() {
        if let film = film {
            onFavoriteToggleHandler?(film)
        }
    }

}
