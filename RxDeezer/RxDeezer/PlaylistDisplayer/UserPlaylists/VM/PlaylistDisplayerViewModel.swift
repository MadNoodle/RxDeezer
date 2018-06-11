//
//  PlaylistDisplayerViewModel.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 09/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class PlaylistDisplayerViewModel: NSObject {
  static let shared = PlaylistDisplayerViewModel()
  let userId = "2529"
  let disposeBag = DisposeBag()
  var playlistData = Variable<[Playlist]>([])
  var tracklistUrl = Variable<String>("")
  var tracklistData = Variable<[Track]>([])
  var tracks: Observable<[Track]>!
  
  override private init() {
    super.init()
    
  
    requestPlaylist(for: userId)
      .subscribe( onNext: {
        [weak self] dataList in
        self?.playlistData.value = dataList
      }).disposed(by: disposeBag)
    
    tracklistData.asObservable().subscribe { [weak self] data in
      self?.tracks = Observable.just(data.element!)
    }.disposed(by: disposeBag)

    tracklistUrl.asObservable()
      .subscribe(onNext: { [weak self] url in
       
        APIClient.getTracks(for: url) { data in
          
          self?.tracklistData.value = data
         
        }
      }).disposed(by: disposeBag)
   
    
    
  }
  
  public func requestPlaylist(for user: String) -> Observable<[Playlist]> {
    return Observable.create { observer in
      APIClient.getPlaylists(for: user) { result in
          observer.on(.next(result))
          observer.on(.completed)
        }
      return Disposables.create()
      }
    }
  
  public func requestTrackList(for url: String) -> Observable<[Track]> {
    return Observable.create { observer in
      APIClient.getTracks(for: url) { result in
        observer.on(.next(result))
        observer.on(.completed)
      }
      return Disposables.create()
    }
  }
  
  
  }
  


