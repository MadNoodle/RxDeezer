import Foundation
import Alamofire
import RxSwift

typealias Parameters = [String: Any]?
typealias DeezerObject =  [String: Any]
typealias DeezerResponse = (response: Any, serverError: String?)

/**
The API protocol contains all the properties and methods to implement a network client
 */
protocol API {
  var baseUrl: String { get set }
  func requestPlaylists(for user: String, parameters: Parameters) -> Single<DeezerResponse>
  func requestTracks(for playlist: String, parameters: Parameters) -> Single<DeezerResponse>
}


/**
 Implementation of API protocol for Deezer client
 Documentation can be found at: https://developers.deezer.com/api/
 */
class DeezerApi: API {
  
  /// Base url to access Deezer RESTAPI
  var baseUrl: String
  
  /// Custom init for Deezer Client
  ///
  /// - Parameter url: String base url
  init(with url: String) {
    self.baseUrl = url
  }
  
  /// This method request all the playlist a user has on his account
  ///
  /// - Parameters:
  ///   - user: String userId to fetch
  ///   - parameters: Parameters? used to implement different request such as post/deelete/patch
  /// - Returns: Single<DeezerResponse> Observable that returns a tuple (data, internal error) on success
  func requestPlaylists(for user: String, parameters: Parameters) -> Single<DeezerResponse> {
    return Single<DeezerResponse>.create { observer in
      
      // Create Request
      let request = Alamofire.request("\(self.baseUrl)/user/\(user)/playlists", method: .get, parameters: nil, encoding: URLEncoding(boolEncoding: .numeric), headers: nil)
      
      // trigger request
      request.validate().responseJSON { response in
        
        // check for successful connexion
        switch response.result{
        case .success:
          guard let data = response.value as? DeezerObject else {
            return }
          
          // check if deezer server produces an error
          if data["error"] != nil {
            // send back response with error message
            let response: DeezerResponse = (data,self.parseDeezerError(data: data))
            observer(.success(response))
          }
            observer(.success((data,nil)))
          // Return an error if no connection to the server
        case .failure(let error):
          observer(.error(error))
        }
      }
      return Disposables.create {
        request.cancel()
      }
    }
  }
  
  /// This method request all the tracks  for a particular playlist
  ///
  /// - Parameters:
  ///   - user: String Playlist id url fetched from resquestPlaylit()
  ///   - parameters: Parameters? used to implement different request such as post/deelete/patch
  /// - Returns: Single<DeezerResponse> Observable that returns a tuple (data, internal error) on success
  func requestTracks(for playlist: String, parameters: Parameters) -> Single<DeezerResponse> {
    return Single<DeezerResponse>.create { observer in
      // create request
      let request = Alamofire.request(playlist, method: .get, parameters: nil, encoding: URLEncoding(boolEncoding: .numeric), headers: nil)
      // trigger request
      request.validate().responseJSON { response in
        // properties to temp store the results to return
        var objects = [DeezerObject]()
        
         // check for successful connexion
        switch response.result{
        case .success:
          guard let data = response.value as? [String: Any] else { return }
          // check if deezer server produces an error
          if data["error"] != nil {
            // send back response with error message
            let response: DeezerResponse = (data,self.parseDeezerError(data: data))
            observer(.success(response))
          }
            if let json = data ["data"] as? [DeezerObject] {
          objects = json
          // attention array d object
          observer(.success((objects,nil)))
          }
        case .failure(let error):
          observer(.error(error))
          
        }
      }
      return Disposables.create {
        request.cancel()

      }
    }
  }
  
 /// Converts internal Server Errors to a error message string
 ///
  /// - Parameter data: [String: Any] server response
 /// - Returns: String Error message
 func parseDeezerError(data: [String: Any]) -> String {
  // property to temp store the result to return
    var errorMessage: String!
  // check the server data
    if let serverResponse =  data["error"] as? [String: Any] {
      if let code = serverResponse["code"] as? Int {
        // convert to error message string
        errorMessage = DeezerErrors.checkErrorCode(code).localizedDescription
      }
      
    }
    return errorMessage
  }
}



