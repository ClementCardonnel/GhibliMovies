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
    
    var film: Film? {
        didSet {
            title = film?.title
            updateFavoriteButton()
        }
    }
    
    /// This handler will be called when the user taps the favorite button of this view controller
    var onFavoriteToggleHandler: FilmHandler?
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var favoriteButton = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(onFavoriteButtonTap))
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = favoriteButton
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
    
    
    
    @objc private func onFavoriteButtonTap() {
        if let film = film {
            onFavoriteToggleHandler?(film)
        }
    }

}
