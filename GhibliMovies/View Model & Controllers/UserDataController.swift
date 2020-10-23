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
    
    /// The user's favorite movies (an in-memory representation of UserDefailts)
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
        if let favoriteValue = favorites[filmId] {
            return favoriteValue
        } else {
            return false
        }
    }
    
    /// Update the UserDefaults (and notify observers)
    func updateFavorite(film: Film) {
        // Update the local representation of UserDefaults
        favorites[film.id] = film.isFavorite
        
        // Save to UserDefaults
        queue.async { [weak self] in
            guard let self = self else { return }
            UserDefaults.standard.setValue(self.favorites, forKey: Constants.favoriteKey)
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
