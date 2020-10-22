//
//  UIContextMenuConfiguration+MovieCell.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 21/10/2020.
//

import UIKit

extension UIContextMenuConfiguration {
    
    /// Context Menu Configuration for movie cells in a collection view.
    /// - Parameters:
    ///   - film: The film that should receive the menu
    ///   - presenter: A view controller able to present an activity view controller
    /// - Returns: A configuration object.
    static func movieCell(film: Film, presenter: UIViewController) -> UIContextMenuConfiguration {
        let isFavorite = UserDataController.shared.isFavorite(film)
        
        let favoriteAction: UIAction
        if isFavorite {
            favoriteAction = UIAction(title: "Remove from Favorites", image: UIImage(systemName: "heart.slash"), handler: { (_) in
                UserDataController.shared.removeFromFavorites(film)
            })
        } else {
            favoriteAction = UIAction(title: "Favorite", image: UIImage(systemName: "heart"), identifier: nil, handler: { (_) in
                UserDataController.shared.setAsFavorite(film)
            })
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (_) -> UIMenu? in
            UIMenu(title: film.title, children: [favoriteAction])
        }
    }
    
}

