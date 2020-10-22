//
//  Film+Cover.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 22/10/2020.
//

import UIKit

extension Film {
    
    /// The film's cover retrieved from Assets.xcassets as an optional UIImage
    var cover: UIImage? {
        Cover(rawValue: id)?.image
    }
    
}



// MARK: - Cover Constants

fileprivate extension Film {
    
    /*
     We never do such things in real life programming,
     but I felt that putting the API identifiers into constants
     would be better for retrieving the bundled covers.
     */
    enum Cover: String {
        case castleSky = "2baf70d1-42bb-4437-b551-e5fed5a87abe"
        case fireflies = "12cfb892-aac0-4c5b-94af-521852e46d6a"
        case totoro = "58611129-2dbc-4a81-a72f-77ddfc1b1b49"
        case kikiDelivery = "ea660b10-85c4-4ae3-8a5f-41cea3648e3e"
        case yesterday = "4e236f34-b981-41c3-8c65-f8c9000b94e7"
        case rosso = "ebbb6b7c-945c-41ee-a792-de0e43191bd8"
        case pomPoko = "1b67aa9a-2e4a-45af-ac98-64d6ad15b16c"
        case whispers = "ff24da26-a969-4f0e-ba1e-a122ead6c6e3"
        case mononoke = "0440483e-ca0e-4120-8c50-4c8cd9b965d6"
        case yamadas = "45204234-adfd-45cb-a505-a8e7a676b114"
        case spirited = "dc2e6bd1-8156-4886-adff-b39e6043af0c"
        case catReturns = "90b72513-afd4-4570-84de-a56c312fdf81"
        case movingCastle = "cd3d059c-09f4-4ff3-8d63-bc765a5184fa"
        case earthsea = "112c1e67-726f-40b1-ac17-6974127bb9b9"
        case ponyo = "758bf02e-3122-46e0-884e-67cf83df1786"
        case arrietty = "2de9426b-914a-4a06-a3a0-5e6d9d3886f6"
        case poppy = "45db04e4-304a-4933-9823-33f389e8d74d"
        case wind = "67405111-37a5-438f-81cc-4666af60c800"
        case kaguya = "578ae244-7750-4d9f-867b-f3cd3d6fecf4"
        case marnie = "5fdfb320-2a02-49a7-94ff-5ca418cae602"
        
        var image: UIImage? {
            switch self {
            case .castleSky:
                return UIImage(named: "castleSky")
            case .fireflies:
                return UIImage(named: "fireflies")
            case .totoro:
                return UIImage(named: "totoro")
            case .kikiDelivery:
                return UIImage(named: "kikiDelivery")
            case .yesterday:
                return UIImage(named: "yesterday")
            case .rosso:
                return UIImage(named: "rosso")
            case .pomPoko:
                return UIImage(named: "pompoko")
            case .whispers:
                return UIImage(named: "whispers")
            case .mononoke:
                return UIImage(named: "mononoke")
            case .yamadas:
                return UIImage(named: "yamadas")
            case .spirited:
                return UIImage(named: "spirited")
            case .catReturns:
                return UIImage(named: "catReturns")
            case .movingCastle:
                return UIImage(named: "movingCastle")
            case .earthsea:
                return UIImage(named: "earthsea")
            case .ponyo:
                return UIImage(named: "ponyo")
            case .arrietty:
                return UIImage(named: "arrietty")
            case .poppy:
                return UIImage(named: "poppyHill")
            case .wind:
                return UIImage(named: "wind")
            case .kaguya:
                return UIImage(named: "kaguya")
            case .marnie:
                return UIImage(named: "marnie")
            }
        }
    }
    
}
