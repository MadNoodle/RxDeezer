//
//  DeezerClient.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 10/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
  
  static func getPlaylists(for user: String, completion: @escaping ([Playlist])->Void) {
    var playlists = [Playlist]()
    Alamofire.request(APIRouter.playlists(user: user)).responseJSON { response in
      guard let result = response.result.value as? [String: Any],
        let json = result ["data"] as? [[String: Any]] else { return }
        for playlist in json {
          let newPlaylist = Playlist(json: playlist)
          playlists.append(newPlaylist!)
        }
      completion(playlists)
      
  }
}
  
  static func getTracks(for url: String, completion: @escaping ([Track])->Void) {
    var tracks = [Track]()
    Alamofire.request(url).responseJSON { response in
      guard let result = response.result.value as? [String: Any],
        let json = result ["data"] as? [[String: Any]] else { return }
      for track in json {
        let newTrack = Track(json: track)
        tracks.append(newTrack!)
      }
      completion(tracks)
    }
  }
 

}
