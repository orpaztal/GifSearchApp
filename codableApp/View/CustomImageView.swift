//
//  CustomImageView.swift
//  codableApp
//
//  Created by or paztal on 05/07/2019.
//  Copyright © 2019 Or paz tal. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        image = #imageLiteral(resourceName: "loading") // since it's reuseable cells, cleans the prior image from the cell

        guard let url = URL(string: urlString) else { return }
        
        // check for cached image (by its url), if exist then returns the cached image
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            print("Returned cached gif for \(url)")
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                if let data = data {
                    guard let imageToCache = UIImage(data: data) else { return }
                    
                    // since the downloads are asyc, this checks that the image is loaded in the correct cell
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    
                    imageCache.setObject(imageToCache, forKey: urlString as NSString)
                }
            }
        }).resume()
    }
    
}
