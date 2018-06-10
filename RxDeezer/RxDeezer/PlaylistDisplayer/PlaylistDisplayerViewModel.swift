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
  
  let disposeBag = DisposeBag()
  let playlistData = Variable<[Playlist]>([])
  let tracklistData = Variable<[Song]>([])
  
  init(request: String) {
    super.init()
    self.parse(urlRequest: request, type: .playlists)
  }
  public func request(_ url: String) -> Observable<Any?> {
    return Observable.create { observer in
      let request: DataRequest = Alamofire.request(url)
      
      request.responseJSON { response in
        if let error = response.result.error {
          observer.on(.error(error))
        } else {
          observer.on(.next(response.result.value ))
          observer.on(.completed)
        }
      }
      
      return Disposables.create {
        request.cancel()
      }
    }
  }
  
  enum RequestType {
    case playlists, tracklist
  }
  
  public func parse(urlRequest: String, type: RequestType) {
    
    request(urlRequest).subscribe(onNext: { data in
      guard let result = data as? [String: Any],
      let json = result ["data"] as? [[String: Any]] else { return }
      switch type {
      case .playlists:
        for playlist in json {
          let newPlaylist = Playlist(json: playlist)
         // print((newPlaylist?.title)!)
          self.playlistData.value.append(newPlaylist!)
        }
      case .tracklist:
        for tracks in json {
          let newTrack = Song(json: tracks)
        print((newTrack?.title)!)
          self.tracklistData.value.append(newTrack!)
        }
      }
      
    
        }).disposed(by: disposeBag)
  }
}


struct Song {
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
    
  }
 
  
}
