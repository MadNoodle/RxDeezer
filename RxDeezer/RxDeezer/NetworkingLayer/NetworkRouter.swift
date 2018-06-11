//
//  NetworkRouter.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 10/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
  var method: HTTPMethod { get }
  var path: String { get }
  var parameters: Parameters? { get }
}

enum APIRouter: APIConfiguration {
  
  case playlists(user: String)
  case tracklist(id: Int)
  
  // MARK: - HTTPMethod
  internal var method: HTTPMethod {
    switch self {
    case .playlists, .tracklist :
      return .get
    
    }
  }
  
  // MARK: - Path
  internal var path: String {
    switch self {
    case .playlists(let userId):
      return "user/\(userId)/playlists/"
     
    case .tracklist(let id):
      return "playlist/\(id)/tracks"
    }
  }
  
  // MARK: - Parameters
  internal var parameters: Parameters? {
    switch self {
    case .playlists(let userId):
      return [Constants.APIParameterKey.userId: userId]
    case .tracklist(let id):
      return [Constants.APIParameterKey.id: id]
    }
  }
  
  // MARK: - URLRequestConvertible
  func asURLRequest() throws -> URLRequest {
    let url = try Constants.ProductionServer.baseURL.asURL()
    
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    
    // HTTP Method
    urlRequest.httpMethod = method.rawValue
    
    // Common Headers
    urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
    urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
    
    // Parameters
    if let parameters = parameters {
      do {
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
      } catch {
        throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
      }
    }
    
    return urlRequest
  }
}
