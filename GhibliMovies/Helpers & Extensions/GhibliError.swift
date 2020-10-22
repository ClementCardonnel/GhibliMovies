//
//  GhibliError.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 21/10/2020.
//

import Foundation

/// Custom errors for the project
enum GhibliError: LocalizedError {
    /// There was an issue with the API URL
    case invalidUrl
    
    /// The app wasn't able to parse the API data
    case failedToParseFilm
}
