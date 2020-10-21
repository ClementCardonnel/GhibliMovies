//
//  Film.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 21/10/2020.
//

import Foundation

struct Film {
    let id: String
    let title: String
    let description: String
    let director: String
    let producer: String
    let releaseDate: Int
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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        director = try values.decode(String.self, forKey: .director)
        producer = try values.decode(String.self, forKey: .producer)
        description = try values.decode(String.self, forKey: .description)
        
        // These values first have to be casted to another type
        let stringDate = try values.decode(String.self, forKey: .releaseDate)
        let stringScore = try values.decode(String.self, forKey: .score)
        let stringUrl = try values.decode(String.self, forKey: .url)
        
        if let intDate = Int(stringDate),
           let intScore = Int(stringScore),
           let url = URL(string: stringUrl) {
            releaseDate = intDate
            score = intScore
            self.url = url
        } else {
            throw GhibliError.failedToParseFilm
        }
    }
    
}
