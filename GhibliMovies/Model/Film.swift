//
//  Film.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 21/10/2020.
//

import Foundation

/**
 Fillm is the major data structure of the app.
 
 It represents a film, with all its the informations.
 */
struct Film {
    let id: String
    
    let title: String
    
    let description: String
    
    let director: String
    
    let producer: String
    
    /// A release date (gregorian year)
    let releaseDate: Int
    
    /// Scrore from 0 to 100
    let score: Int
    
//    let people
    
    let url: URL
}



// MARK: - Decodable

extension Film: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case director
        case producer
        case releaseDate = "release_date"
        case score = "rt_score"
        case url
        case people
    }
    
    // Custom decodable implementation that casts some elements to more appropriate Swift types.
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the most straightforward values
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        director = try values.decode(String.self, forKey: .director)
        producer = try values.decode(String.self, forKey: .producer)
        description = try values.decode(String.self, forKey: .description)
        
        // These values first have to be casted to string…
        let stringDate = try values.decode(String.self, forKey: .releaseDate)
        let stringScore = try values.decode(String.self, forKey: .score)
        let stringUrl = try values.decode(String.self, forKey: .url)
        
        // … And then casted to another type.
        if let intDate = Int(stringDate),
           let intScore = Int(stringScore),
           let url = URL(string: stringUrl) {
            releaseDate = intDate
            score = intScore
            self.url = url
        } else {
            // Something went wrong during the parsing.
            throw GhibliError.failedToParseFilm
        }
    }
    
}



// MARK: - Hashable

extension Film: Hashable {
    
    func hash(into hasher: inout Hasher) {
        // hash value will be exhaustive
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(director)
        hasher.combine(producer)
        hasher.combine(releaseDate)
        hasher.combine(score)
        hasher.combine(url)
    }

    static func == (lhs: Film, rhs: Film) -> Bool {
        // To compare two movies, we only need to check their ids.
        return lhs.id == rhs.id
    }
    
}
