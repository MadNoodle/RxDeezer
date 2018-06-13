import Foundation
import Alamofire
import RxSwift


typealias Parameters = [String: Any]?


protocol API {
  static func requestPlaylists(for user: String, parameters: Parameters) -> Single<[Playlist]>
  static func requestTracks(for playlist: String, parameters: Parameters) -> Single<[Track]>
}


class DeezerApi: API {
  static func requestPlaylists(for user: String, parameters: Parameters) -> Single<[Playlist]> {
    return Single<[Playlist]>.create { observer in
      
      var results = [Playlist]()
      
      Alamofire.request("https://api.deezer.com/user/\(user)/playlists", method: .get, parameters: nil, encoding: URLEncoding(boolEncoding: .numeric), headers: nil).validate().responseJSON { response in
        
        switch response.result{
        case .success:
          
          guard let data = response.value as? [String: Any] else {
            return }
          if data["error"] as? [String: Any] != nil {
            print("il y a une erreur")
            if let serverResponse =  data["error"] as? [String: Any] {
              if let code = serverResponse["code"] as? Int {
                observer(.error(DeezerErrors.checkErrorCode(code)))
              }
            }
          }
          
          if let json = data ["data"] as? [[String: Any]] {
            
            for playlist in json {
              let newPlaylist = Playlist(json: playlist)
              results.append(newPlaylist!)
            }
          }
          
          observer(.success(results))
          
        case .failure(let error):
          observer(.error(error))
        }
      }
      return Disposables.create {
      }
    }
  }
  
  
  static func requestTracks(for playlist: String, parameters: Parameters) -> Single<[Track]> {
    return Single<[Track]>.create { observer in
      var results = [Track]()
      Alamofire.request(playlist, method: .get, parameters: nil, encoding: URLEncoding(boolEncoding: .numeric), headers: nil).validate().responseJSON { response in
        
        switch response.result{
        case .success:
          guard let data = response.value as? [String: Any],
            let json = data ["data"] as? [[String: Any]] else { return }
          for song in json {
            let newSong = Track(json: song)
            results.append(newSong!)
          }
          observer(.success(results))
          
        case .failure(let error):
          observer(.error(error))
          
        }
      }
      return Disposables.create {
        
      }
    }
  }
}



