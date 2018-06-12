//
//  extensionUIImage+Cache.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 11/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import UIKit
/// Initialize the cache storage for images
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
  
  /// Load and cache an image with the image url as string
  ///
  /// - Parameter urlString: String
  func load(urlString: String) {
    // Convert string to url
    let url = URL(string: urlString)
    image = nil
    
    // check and load image from cache
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
      self.image = imageFromCache
      return
    }
    guard let imageUrl = url else { return}
    // Fetch image from remote
    let task = URLSession.shared.dataTask(with: imageUrl) { (data, _, error) in
      // send to bg queue
      DispatchQueue.main.async {
        // unwrap image as data
        if let data = data {
          // Store in cache
          if let imageToCache = UIImage(data: data) {
            imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
            self.image = imageToCache
          }
        } else if let error = error {
          print("USER INFO ERROR: \(error.localizedDescription)")
          // placeholder Image
          self.image = #imageLiteral(resourceName: "logonb")
        }
      }
    }
    task.resume()
  }
}
