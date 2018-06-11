//
//  DeezerTracks.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 11/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let deezerTracks = try? JSONDecoder().decode(DeezerTracks.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseDeezerTracks { response in
//     if let deezerTracks = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire


struct Track {
  var title: String = ""
  init?(json: [String:Any]) {
    if let newTitle = json["title"] as? String {
      self.title = newTitle
    }
  }
}

struct Playlist{
  var title: String = ""
  var pictureUrl: String = ""
  var smallPictureUrl: String = ""
  var trackList: String = ""
  var creator: String = ""
  var duration: String = ""
  init?(json: [String:Any]) {
    
    if let newTitle = json["title"] as? String {
      self.title = newTitle
    }
    
    if let picture = json["picture"] as? String {
      self.pictureUrl = picture
    }
    
    if let thumbnail = json["picture_medium"] as? String {
      self.smallPictureUrl = thumbnail
    }
    if let tracks = json["tracklist"] as? String {
      self.trackList = tracks
    }
    if let newCreator = json["creator"] as? [String: Any] {
      if let name = newCreator["name"] as? String {
        self.creator = name
      }
    }
    if let newDuration = json["duration"] as? Int {
      self.duration = newDuration.secondsToHoursMinutesSeconds()
    }
    
  }
  
  
}
