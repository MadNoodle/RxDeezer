//
//  Constants.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 10/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
  
  // Should be private bu opened for purpose demo
 
    struct DevConfig {
      static let userId = "2529"
      static let baseURL =  "https://api.deezer.com/"
      static let appId = "282964"
      static let appSecret =  "7c28f134dfeff5dbf613959695f95f94"
      static let tokenizer = "https://connect.deezer.com/oauth/access_token.php?app_id=282964&secret=7c28f134dfeff5dbf613959695f95f94&code=frf1199ba898e62b972858d5abf33eab"
      static let complementaryColor = UIColor(red: 28/255, green: 56/255, blue: 95/255, alpha: 1)
    }
  
    struct APIParameterKey {
      static let userId = "userId"
      static let id = "id"
    }
  }
  
  enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
  }
  
  enum ContentType: String {
    case json = "application/json"
  
}
