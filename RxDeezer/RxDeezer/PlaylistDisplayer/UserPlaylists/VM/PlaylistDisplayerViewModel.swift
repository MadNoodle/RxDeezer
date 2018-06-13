//
//  PlaylistDisplayerViewModel.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 09/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import RxSwift

class PlaylistDisplayerViewModel: NSObject {
  
  // MARK: - PROPERTIES
  /// entrance point for singleton pattern
  static let shared = PlaylistDisplayerViewModel()
  /// Bag that stores All disposables and dealloc them if neeeded
  let disposeBag = DisposeBag()
  var playlistData = Variable<[Playlist]>([])
  var selectedPlaylist = Variable<Playlist>(Playlist(json: ["":""])!)
  var tracklistData = Variable<[Track]>([])
  
  
  
  /// Private initializer to match singleton pattern
  override private init() {
    super.init()
    startObserving()
  }
  
  private func startObserving() {
    // fetch data for user
    DeezerApi.requestPlaylists(for: Constants.DevConfig.userId, parameters: nil)
      .subscribe {
        switch $0{
          
        case .success (let data):
          self.playlistData.value = data
        case .error(let error):
          let serverError = error as? DeezerErrors
          print("Error:\((serverError?.localizedDescription)!)")
          
        }
      }.disposed(by: disposeBag)
    
    // Initialize selected playlist behavior in PlaylistCollection controller
    selectedPlaylist.asObservable().subscribe({ [weak self] playlist in
      self?.requestTrackList(for: (playlist.element?.trackList)!)
    })
    
  }
  

  
  private func requestTrackList(for url: String) {
    
      DeezerApi.requestTracks(for: url, parameters: nil).subscribe {
        switch $0{
          
        case .success (let data):
          self.tracklistData.value = data
        case .error(let error):
          if let serverError = error as? DeezerErrors {
            print(serverError.localizedDescription)
          }
          
        }
      }.disposed(by: disposeBag)
      
    
    }
  
  
  
}



