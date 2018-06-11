////
////  Models.swift
////  RxDeezer
////
////  Created by Mathieu Janneau on 10/06/2018.
////  Copyright © 2018 Mathieu Janneau. All rights reserved.
////
//
//import Foundation
//
//
//
////struct Song {
////  var title: String = ""
////  init?(json: [String:Any]) {
////    if let newTitle = json["title"] as? String {
////      self.title = newTitle
////    }
////  }
////}
////
////struct Playlist{
////  var id: String = ""
////  var title: String = ""
////  var pictureUrl: String = ""
////  var smallPictureUrl: String = ""
////  var trackList: String = ""
////
////  init?(json: [String:Any]) {
////    if let _id = json["id"] as? String {
////      self.id = _id
////    }
////    if let _title = json["title"] as? String {
////      self.title = _title
////    }
////
////    if let _pictureUrl = json["picture"] as? String {
////      self.pictureUrl = _pictureUrl
////    }
////
////    if let _smallPictureUrl = json["picture_medium"] as? String {
////      self.smallPictureUrl = _smallPictureUrl
////    }
////    if let _trackList = json["tracklist"] as? String {
////      self.trackList = _trackList
////
////    }
////
////  }
////
////
////}
//
//// To parse the JSON, add this file to your project and do:
////
////   let deezerUser = try? JSONDecoder().decode(DeezerUser.self, from: jsonData)
////
//// To parse values from Alamofire responses:
////
////   Alamofire.request(url).responseDeezerUser { response in
////     if let deezerUser = response.result.value {
////       ...
////     }
////   }
//
//import Foundation
//import Alamofire
//
//struct DeezerUser: Codable {
//  let data: [Playlist]
//  let checksum: String
//  let total: Int
//  let next: String
//}
//
//struct Playlist: Codable {
//  let id: Int
//  let title: String
//  let duration: Int
//  let datumPublic, isLovedTrack, collaborative: Bool
//  let rating, nbTracks, fans: Int
//  let link, picture, pictureSmall, pictureMedium: String
//  let pictureBig, pictureXl, checksum, tracklist: String
//  let creationDate: String
//  let timeAdd, timeMod: Int?
//  let creator: Creator
//  let type: DatumType
//  
//  enum CodingKeys: String, CodingKey {
//    case id, title, duration
//    case datumPublic = "public"
//    case isLovedTrack = "is_loved_track"
//    case collaborative, rating
//    case nbTracks = "nb_tracks"
//    case fans, link, picture
//    case pictureSmall = "picture_small"
//    case pictureMedium = "picture_medium"
//    case pictureBig = "picture_big"
//    case pictureXl = "picture_xl"
//    case checksum, tracklist
//    case creationDate = "creation_date"
//    case timeAdd = "time_add"
//    case timeMod = "time_mod"
//    case creator, type
//  }
//}
//
//struct Creator: Codable {
//  let id: Int
//  let name: Name
//  let tracklist: Tracklist
//  let type: CreatorType
//}
//
//enum Name: String, Codable {
//  case dadbond = "dadbond"
//}
//
//enum Tracklist: String, Codable {
//  case httpsAPIDeezerCOMUser2529Flow = "https://api.deezer.com/user/2529/flow"
//}
//
//enum CreatorType: String, Codable {
//  case user = "user"
//}
//
//enum DatumType: String, Codable {
//  case playlist = "playlist"
//}
//
//// MARK: - Alamofire response handlers
//
//extension DataRequest {
//  fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
//    return DataResponseSerializer { _, response, data, error in
//      guard error == nil else {
//        return .failure(error!) }
//      
//      guard let data = data else {
//        return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
//      }
//      
//      return Result { try JSONDecoder().decode(T.self, from: data) }
//    }
//  }
//  
//  @discardableResult
//  fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
//    return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
//  }
//  
//  @discardableResult
//  func responseDeezerUser(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<DeezerUser>) -> Void) -> Self {
//    return responseDecodable(queue: queue, completionHandler: completionHandler)
//  }
//  
//  @discardableResult
//  func responseDeezerTracks(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<DeezerTracks>) -> Void) -> Self {
//    return responseDecodable(queue: queue, completionHandler: completionHandler)
//  }
//}
