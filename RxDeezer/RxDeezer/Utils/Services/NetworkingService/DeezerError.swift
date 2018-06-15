//
//  DeezerError.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 13/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

/**
 This enum describes all the Deezer Api internal Server Errors
 DOCUMENTATION : https://developers.deezer.com/api/errors
 */
enum DeezerErrors: Error {
  case quotaException
  case itemsLimitExceeded
  case OAuthPermissionException
  case invalidToken
  case parameterException
  case missingParameters
  case invalidQuery
  case busyService
  case noData
  case unknownError
  
  /// NSLocalized Strings for errors
  var localizedDescription: String {
    switch self {
    case .quotaException:
      return NSLocalizedString("User exceed is request quota.", comment: "My error")
    case .itemsLimitExceeded:
      return NSLocalizedString("Items Limit Exceeded.", comment: "My error")
    case .OAuthPermissionException:
      return NSLocalizedString("OAuth Permission Exception.", comment: "My error")
    case .invalidToken:
      return NSLocalizedString("Invalid Token.", comment: "My error")
    case .parameterException:
      return NSLocalizedString("Parameter Exception.", comment: "My error")
    case .missingParameters:
      return NSLocalizedString("Missing Parameters.", comment: "My error")
    case .invalidQuery:
      return NSLocalizedString("Invalid Query.", comment: "My error")
    case .busyService:
      return NSLocalizedString("Sorry the Deezer Service is busy.", comment: "My error")
    case .noData:
      return NSLocalizedString("There is no data", comment: "My error")
    case .unknownError:
      return NSLocalizedString("Unknown error.", comment: "My error")
    }
  }
  
  /// Converts code to error string
  ///
  /// - Parameter errorCode: Int
  /// - Returns: DeezerError
  static func checkErrorCode(_ errorCode: Int) -> DeezerErrors {
    switch errorCode {
    case 4:
      return .quotaException
    case 100:
      return .itemsLimitExceeded
    case 200:
      return .OAuthPermissionException
    case 300:
      return .invalidToken
    case 500:
      return .parameterException
    case 501:
      return .missingParameters
    case 600:
      return .invalidQuery
    case 700:
      return .busyService
    case 800:
      return .noData
      
    default:
      return .unknownError
    }
  }
}
