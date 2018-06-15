//
//  PlaylistDisplayerViewModel.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 09/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import RxSwift

/**
 The View Model is assocaited with HomeViewController.
 It prepares all the data to be displayed in the view and children's VCs
 
 -- Data Flow:
 ```
 
        init                 react to newValue
 userId ---> Fetch Playlists----------------->PlaylistData---------->TrackList----- Deallocate Tracklist data
                                                  |                     |                |
                                                  |                     |                |
                                              update UI-->update header_|            update UI
                                                              |                          |
                                           user Input(tap) ___|  user Input(Scrollup) ___|
 ```
 */
class PlaylistDisplayerViewModel: NSObject {
  
  // MARK: - PROPERTIES
  /// entrance point for singleton pattern
  static let shared = PlaylistDisplayerViewModel()
  /// Private initializer to match singleton pattern
  override private init() {
    super.init()
    startObserving(Constants.DevConfig.userId)
  }
  
  /// Start DeezerClient API
  let deezerClient = DeezerApi(with: Constants.DevConfig.baseURL)
  /// Bag that stores All disposables and dealloc them if neeeded
  let disposeBag = DisposeBag()
  
  // MARK: - PROPERTIES TO EXPOSE
  
  /// Playlist Data Variable to expose Paylist for a user to other
  var playlistData = Variable<[Playlist]>([])
  /// Playlist Data Variable to receive and expose Paylist for a user to other
  var selectedPlaylist = Variable<Playlist>(Playlist(json: ["":""])!)
  /// Server error Variable to expose possible errors in Alert
  var serverError = Variable<String>("")
  /// Tracks Data Variable to expose Paylist for a user to other
  var tracklistData = Variable<[Track]>([])
  
  
  /// Start observing all variables.
  ///
  /// - Parameter user: String userId
  private func startObserving(_ user: String) {
    // fetch data for user
    deezerClient.requestPlaylists(for: user, parameters: nil)
      .subscribe {
        switch $0{
        // server connection succeeded
        case .success (let data):
          // check if server error
          if data.serverError != nil {
            self.serverError.value = data.serverError!
          }
          // Display playlist
          self.playlistData.value = self.parsePlaylist(data: data.response as! DeezerObject)
          
        // Server Connection error cannot be tested
        case .error:
          break
        }
      }.disposed(by: disposeBag)
    
    
    // Initialize selected playlist behavior in PlaylistCollection controller
    _ = selectedPlaylist.asObservable().subscribe({ [weak self] playlist in
      self?.requestTrackList(for: (playlist.element?.trackList)!)
    }).disposed(by: disposeBag)
    
  }
  
  
  /// Calls The Deezer Client to retrieve all tracks for a playlist
  ///
  /// - Parameter url: String
  private func requestTrackList(for url: String) {
    // request tracks
    deezerClient.requestTracks(for: url, parameters: nil).subscribe {
      switch $0{
      // Server Connection succeeded
      case .success (let data):
        // if error displays alert
        if data.serverError != nil {
          self.serverError.value = data.serverError!
        }
        // display data
        self.tracklistData.value = self.parseDeezerTracks(data: data.response as! [DeezerObject])
       // Server connection error case
      case .error:
        // not implemented
        break
      }
      }.disposed(by: disposeBag)
    
    
  }
  
  
  /// Converts Server response to Local model Playlist
  ///
  /// - Parameter data: DeezerObject containing data and error
  /// - Returns: [Playlist]
  func parsePlaylist(data: DeezerObject) -> [Playlist] {
    // property to temp store result
    var results = [Playlist]()
    if let json = data ["data"] as? [DeezerObject] {
      //DeezerObject containing data and error
      for playlist in json {
        let newPlaylist = Playlist(json: playlist)
        results.append(newPlaylist!)
      }
    }
    return results
  }

  /// Converts Server response to Local model Tracks
  ///
  /// - Parameter data: DeezerObject containing data and error
  /// - Returns: [Track]
  func parseDeezerTracks(data: [DeezerObject]) -> [Track] {
    var tracks = [Track]()
    // Create track for each entry
    for song in data {
      
      let newSong = Track(json: song)
      tracks.append(newSong!)
    }
    return tracks
  }
  
  
}



