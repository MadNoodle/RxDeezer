//
//  Constants.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 10/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

struct Constants {
 
 
    struct ProductionServer {
      static let baseURL =  "https://api.deezer.com/"
      static let appId = "282964"
      static let appSecret =  "7c28f134dfeff5dbf613959695f95f94"
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
