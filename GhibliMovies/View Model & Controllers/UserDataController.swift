//
//  UserDataController.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 22/10/2020.
//

import Foundation

/**
 A singleton controller object that makes the interface between UserDefaults and the rest of the app.
 */
final class UserDataController {
    
    // MARK: Properties
    
    /// The user's favorite movies
    private var favorites: [String: Bool]
    
    /// A serial queue to apply our changes to UserDefaults without hurting performance and without inducing concurrency issues.
    private let queue = DispatchQueue(label: "UserDataQueue", qos: .utility)
    
    
    
    // MARK: Singleton & Init
    
    static let shared = UserDataController()
    
    private init() {
        if let favorites = UserDefaults.standard.dictionary(forKey: Constants.favoriteKey) as? [String: Bool] {
            // Retrieve and set favorites from UserDefaults
            self.favorites = favorites
        } else {
            // Initialize an empty favorites dictionary
            self.favorites = [String: Bool]()
        }
    }
    
    
    
    /// Is a film a favorite in UserDefaults?
    func isFavorite(filmId: String) -> Bool {
        favorites[filmId] ?? false
    }
    
    /// Update the UserDefaults (and notify observers)
    func updateFavorite(film: Film) {
        favorites[film.id] = film.isFavorite
        
        /*
         We put `favorites` in the capture list so that it's the current state that is saved and not an eventual future one.
         */
        queue.async { [favorites] in
            UserDefaults.standard.setValue(favorites, forKey: Constants.favoriteKey)
        }
    }
    
}



// MARK: - Constants

private extension UserDataController {
    
    struct Constants {
        /// UserDefaults keys to the favorites
        static let favoriteKey = "userFavorites"
    }
    
}
