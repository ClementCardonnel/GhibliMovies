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
    private var favorites: [String: Any]
    
    /// A serial queue to apply our changes to UserDefaults without hurting performance and without inducing concurrency issues.
    private let queue = DispatchQueue(label: "UserDataQueue", qos: .utility)
    
    
    
    // MARK: Singleton & Init
    
    static let shared = UserDataController()
    
    private init() {
        if let favorites = UserDefaults.standard.dictionary(forKey: Constants.favoriteKey) {
            // Retrieve and set favorites from UserDefaults
            self.favorites = favorites
        } else {
            // Initialize an empty favorites dictionary
            self.favorites = [String: Any]()
        }
    }
    
    
    
    /// Set a movie as favorite
    func setAsFavorite(_ film: Film) {
        favorites[film.id] = true
        update()
    }
    
    /// Remove a movie from the favorites list
    func removeFromFavorites(_ film: Film) {
        favorites[film.id] = false
        update()
    }
    
    /// Check if an individual movie is a favorite of our user or not.
    func isFavorite(_ film: Film) -> Bool {
        (favorites[film.id] as? Bool) ?? false
    }
    
    /// Either add or remove the movie to and from the favorites depending on its previous state
    func toggleFavorite(_ film: Film) {
        if isFavorite(film) {
            removeFromFavorites(film)
        } else {
            setAsFavorite(film)
        }
    }
    
    
    
    /// Update the UserDefaults (and notify observers)
    private func update() {
        NotificationCenter.default.post(Notification(name: Self.onUserDataUpdated))
        
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



// MARK: - Notification

extension UserDataController {
    
    /// Called whenever UserData is updated
    static let onUserDataUpdated = Notification.Name("onUserDataUpdated")
    
}
