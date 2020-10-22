//
//  String+Localized.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 21/10/2020.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}
