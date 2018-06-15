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
    
    let hours = self / 3600
    let minutes = self / 60 % 60
    let seconds = self % 60
    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
  }
  

}
