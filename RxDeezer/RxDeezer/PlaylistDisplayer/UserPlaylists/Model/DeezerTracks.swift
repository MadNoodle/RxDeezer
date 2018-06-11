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

//struct DeezerTracks: Codable {
//  let data: [Track]
//}
//
//struct Track: Codable {
//  let id: Int
//  let readable: Bool
//  let title, titleShort: String
//  let titleVersion: TitleVersion
//  let duration, rank: Int
//  let explicitLyrics: Bool
//  let preview: String
//  let artist: Artist
//  let album: Album
//  let type: TrackType
//
//  enum CodingKeys: String, CodingKey {
//    case id, readable, title
//    case titleShort = "title_short"
//    case titleVersion = "title_version"
//    case duration, rank
//    case explicitLyrics = "explicit_lyrics"
//    case preview, artist, album, type
//  }
//}
//
//struct Album: Codable {
//  let id: Int
//  let title, cover, coverSmall, coverMedium: String
//  let coverBig, coverXl, tracklist: String
//  let type: AlbumType
//
//  enum CodingKeys: String, CodingKey {
//    case id, title, cover
//    case coverSmall = "cover_small"
//    case coverMedium = "cover_medium"
//    case coverBig = "cover_big"
//    case coverXl = "cover_xl"
//    case tracklist, type
//  }
//}
//
//enum AlbumType: String, Codable {
//  case album = "album"
//}
//
//struct Artist: Codable {
//  let id: Int
//  let name, picture, pictureSmall, pictureMedium: String
//  let pictureBig, pictureXl, tracklist: String
//  let type: ArtistType
//
//  enum CodingKeys: String, CodingKey {
//    case id, name, picture
//    case pictureSmall = "picture_small"
//    case pictureMedium = "picture_medium"
//    case pictureBig = "picture_big"
//    case pictureXl = "picture_xl"
//    case tracklist, type
//  }
//}
//
//enum ArtistType: String, Codable {
//  case artist = "artist"
//}
//
//enum TitleVersion: String, Codable {
//  case empty = ""
//  case habitsRemix = "(Habits Remix)"
//}
//
//enum TrackType: String, Codable {
//  case track = "track"
//}


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
