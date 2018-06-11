//
//  extensionInt+toHMS.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 11/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

extension Int {
  
  func secondsToHoursMinutesSeconds() -> String {
    let hmsString = "\(self / 3600):\((self % 3600) / 60):\((self % 3600) % 60)"
    return hmsString
  }
}
