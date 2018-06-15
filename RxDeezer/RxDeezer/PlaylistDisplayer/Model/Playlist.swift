//
//  DeezerTracks.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 11/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation


/// Model Object For Playlist.
/// Properties are Mapped from Deezer user playlist
/// Example json fetching url: https://api.deezer.com/user/2529/playlists
/// Documentation URL : https://developers.deezer.com/api
struct Playlist: Decodable{
  
  /// Title of the playlist
  var title: String = ""
  /// Url of playlist's cover picture
  var pictureUrl: String = ""
  /// Url of playlist's cover picture thumbnail
  var smallPictureUrl: String = ""
  /// Url for playlist's list of tracks
  var trackList: String = ""
  /// Playlist's owner
  var creator: String = ""
  /// Total duration ( format hh:mm:ss)
  var duration: String = ""
  
  /// Failable initializer
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
      // convert from to int to display format hh:mm:ss
      self.duration = newDuration.secondsToHoursMinutesSeconds()
    }
    
  }
  
  
}
