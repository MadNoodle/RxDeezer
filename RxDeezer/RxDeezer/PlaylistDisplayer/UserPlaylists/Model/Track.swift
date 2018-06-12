//
//  Track.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 12/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

/// Model Object For Track( a.k.a song).
/// Properties are Mapped from Deezer user TrackList
/// ### Example json fetching url: https://api.deezer.com/playlist/1549683151/tracks
/// ### Documentation URL : https://developers.deezer.com/api
struct Track {
  
  /// Song title
  var title: String = ""
  /// Singer or band name
  var artist: String = ""
  /// Duration in seconds ( must be converted to be displayed)
  var duration: Int = 0
  
  init?(json: [String:Any]) {
    if let newTitle = json["title"] as? String {
      self.title = newTitle
    }
    if let newArtist = json["artist"] as? [String: Any] {
      if let name = newArtist["name"] as? String {
        self.artist = name
      }
    }
    if let newDuration = json["duration"] as? Int {
      self.duration = newDuration
    }
  }
}
