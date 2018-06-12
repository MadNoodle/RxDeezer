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
    requestPlaylist(for: Constants.DevConfig.userId)
      .subscribe( onNext: {
        [weak self] dataList in
        self?.playlistData.value = dataList
      }).disposed(by: disposeBag)
    
    // Initialize selected playlist behavior in PlaylistCollection controller
    selectedPlaylist.asObservable()
      .subscribe(onNext: { [weak self] playlist in
        // fetch tracks from deezer and store them in tracklistDat VAriable
        APIClient.getTracks(for: playlist.trackList) { data in
          self?.tracklistData.value = data
        }
      }).disposed(by: disposeBag)
    
  }
  
  private func requestPlaylist(for user: String) -> Observable<[Playlist]> {
    return Observable.create { observer in
      APIClient.getPlaylists(for: user) { result in
        observer.on(.next(result))
        observer.on(.completed)
      }
      return Disposables.create()
    }
  }
  
  private func requestTrackList(for url: String) -> Observable<[Track]> {
    return Observable.create { observer in
      APIClient.getTracks(for: url) { result in
        observer.on(.next(result))
        observer.on(.completed)
      }
      return Disposables.create()
    }
  }
  
  
}



