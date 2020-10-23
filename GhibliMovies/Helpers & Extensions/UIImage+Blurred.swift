//
//  UIImage+Blurred.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 23/10/2020.
//

import UIKit

extension UIImage {
    
    /// Apply a gaussian blur to the image, with the given intensity
    func blurred(radius: CGFloat = 50) -> UIImage {
        let ciContext = CIContext(options: nil)

        guard
            let ciImage = CIImage(image: self),
            let ciFilter = CIFilter(name: "CIGaussianBlur") else {
            print("Failed to blur the image.")
            return self
        }
        
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        // actual blur, can be done many times with different
        // radiuses without running preparation again
        ciFilter.setValue(radius, forKey: "inputRadius")
        
        if let outputImage = ciFilter.outputImage {
            let cgImage = ciContext.createCGImage(outputImage, from: ciImage.extent)!
            return UIImage(cgImage: cgImage)
        } else {
            print("Failed to blur the image.")
            return self
        }
    }
    
}

