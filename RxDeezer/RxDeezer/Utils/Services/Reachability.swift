//
//  Reachability.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 14/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
import SystemConfiguration
import Foundation
import RxSwift

/// Reachability Statuses
/// This reflects user's device internet access status
/// - offline: Cannot access internet
/// - online: Can access internet
/// - unknown: unknown
enum Reachability {
  case offline
  case online
  case unknown
  
  init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
    // init the reachability exam
    let connectionRequired = flags.contains(.connectionRequired)
    // the device is reachable or not
    let isReachable = flags.contains(.reachable)
    
    // check if the app needs to access internet
    if !connectionRequired && isReachable {
      self = .online
    } else {
      self = .offline
    }
  }
}

/// Reactive Reachibality Class
class RxReachability {
  /// Singleton access point
  static let shared = RxReachability()
  
  fileprivate init() {}
  
  /// private var for status
  private static var _status = Variable<Reachability>(.unknown)
  
  /// entry point for status var
  var status: Observable<Reachability> {
    get {
      return RxReachability._status.asObservable().distinctUntilChanged()
    }
  }
  
  /// This function returns the current status value
  ///
  /// - Returns: Reachabilty
  class func reachabilityStatus() -> Reachability {
    return RxReachability._status.value
  }
  
  /// Check if device is online online
  ///
  /// - Returns: Bool
  func isOnline() -> Bool {
    switch RxReachability._status.value {
    case .online:
      return true
    case .offline, .unknown:
      return false
    }
  }
  
  /// Low level Reachability access
  private var reachability: SCNetworkReachability?
  
  /// Start observing reachabilty status and returns a bool
  ///
  /// - Parameter host: Dummy host to test (We currently use Deezer api base url)
  /// - Returns: Bool
  func startMonitor(_ host: String) -> Bool {
    if let _ = reachability {
      return true
    }
    
    /// Context to create a reachability profile
    var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
    
    /// Create the reachability the request
    if let reachability = SCNetworkReachabilityCreateWithName(nil, host) {
      
      // examine only the reachability flags
      SCNetworkReachabilitySetCallback(reachability, { (_, flags, _) in
        let status = Reachability(reachabilityFlags: flags)
        // Assign flags value to _status
        RxReachability._status.value = status
      }, &context)
      
      // Schedule the request
      SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
      self.reachability = reachability
      
      return true
    }
    
    return true
  }
  
  /// Stop Monitoring
  func stopMonitor() {
    if let _reachability = reachability {
      SCNetworkReachabilityUnscheduleFromRunLoop(_reachability, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue);
      reachability = nil
    }
  }
  
}
