//
//  Request.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 09/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
  case options = "OPTIONS"
  case get     = "GET"
  case head    = "HEAD"
  case post    = "POST"
  case put     = "PUT"
  case patch   = "PATCH"
  case delete  = "DELETE"
  case trace   = "TRACE"
  case connect = "CONNECT"
}

protocol Request {
  var path        : String            { get }
  var method      : HTTPMethod        { get }
  var bodyParams  : [String: Any]?    { get }
  var headers     : [String: String]? { get }
}

extension Request {
  var method      : HTTPMethod        { return .get }
  var bodyParams  : [String: Any]?    { return nil }
  var headers     : [String: String]? { return nil }
}


class DeezerRequest: Request {
  var path: String
  
  init(path: String){
    self.path = path
  }
}
