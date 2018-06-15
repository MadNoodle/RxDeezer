//
//  RxDeezerTests.swift
//  RxDeezerTests
//
//  Created by Mathieu Janneau on 09/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import RxDeezer

/// This class tests the viewModel and model of the application
class RxDeezerTests: XCTestCase {
  
  /// Dispose bag to correctly deallocate memory
  let disposeBag = DisposeBag()
  /// Instantiate ViewModel for test
  var viewModel: PlaylistDisplayerViewModel!
  
  // MARK: - SETUP
  override func setUp() {
    super.setUp()
    viewModel = PlaylistDisplayerViewModel.shared
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: - CONVENIENCE METHOD
  /// Sourcefile Names for mock json
  enum mocksJSON: String {
    case playlists = "playlistsMock"
    case playlist = "Playlist"
    case tracklists = "tracklistsMock"
    case track = "TrackMock"
  }
  
  /// Convenience json mock loader
  ///
  /// - Parameter mockName: String name of the json file (must be copied in the bundle)
  /// - Returns: Data?
  /// - Throws: Error
  func loadMock(_ mockName: mocksJSON) throws -> Data? {
    // load mock json for playlist
    let bundle = Bundle(for: type(of: self))
    guard let url = bundle.url(forResource: mockName.rawValue, withExtension: "json") else {
      XCTFail("Missing file")
      return nil
    }
    // Convert file to data
    let data = try Data(contentsOf: url)
    return data
  }
  
  // ////////////////// //
  // MARK: - MODEL TEST //
  // ////////////////// //
  
  func testPlaylistObjectCreation() throws {
    /// load mock data for Playlist
    let mock = try loadMock(.playlist)
    /// Property to convert JSON file to Data
    let json = try JSONSerialization.jsonObject(with: mock!, options: []) as! [String : Any]
    /// Mock time to test time formatting
    let intTime = 276
    /// Property to test Playlist initializer
    let playlist = Playlist(json: json)
    
    // Assertions for all properties
    XCTAssertEqual(playlist?.title, "- Ecouter Plus Tard")
    XCTAssertEqual(playlist?.creator, "dadbond")
    XCTAssertEqual(playlist?.duration,intTime.secondsToHoursMinutesSeconds() )
    XCTAssertEqual(playlist?.smallPictureUrl,"https://e-cdns-images.dzcdn.net/images/cover/e5112921e0627e754ea1c1f6bbe137c3/250x250-000000-80-0-0.jpg")
    XCTAssertEqual(playlist?.pictureUrl, "https://api.deezer.com/playlist/1549683151/image")
    XCTAssertEqual(playlist?.trackList, "https://api.deezer.com/playlist/1549683151/tracks")  
  }
  
  func testTrackCreation() throws {
    /// load mock json for track
    let mock = try loadMock(.track)
    /// Property to convert JSON file to Data
    let json = try JSONSerialization.jsonObject(with: mock!, options: []) as! [String : Any]
    /// Property to test Track initializer
    let track = Track(json: json)
    
    // Assertions
    XCTAssertEqual(track?.artist, "Flume")
    XCTAssertEqual(track?.duration, 276)
    XCTAssertEqual(track?.title, "Skin LP Preview")
  }
  
  // //////////////////////// //
  // MARK: - EXTENSIONS TESTS //
  // //////////////////////// //
  
  func testTimeFormatting() {
    /// integer Value to test
    let testTime = 3600
    /// integer Value to test
    let testTime1 = 1432
    /// Converted value for test value 1
    let convertedTime1 = testTime.secondsToHoursMinutesSeconds()
    /// Converted value for test value 2
    let convertedTime2 = testTime1.secondsToHoursMinutesSeconds()
    // Test Assertions
    XCTAssertEqual(convertedTime1, "01:00:00")
    XCTAssertEqual(convertedTime2, "00:23:52")
  }
  
  func testCustomErrors() {
    /// Interanl errors test codes (cf. https://developers.deezer.com/api/errors)
    let testCodes = [4,100,200,300,500,501,600,700,800]
    /// Array to store Results and compare them
    var errorMessages = [String]()
    
    // grab messages according to codes
    for code in testCodes {
      // value to test
      errorMessages.append(DeezerErrors.checkErrorCode(code).localizedDescription)
    }
    
    // Check if everything aligns
    XCTAssertEqual(errorMessages, ["User exceed is request quota.",
                                   "Items Limit Exceeded.",
                                   "OAuth Permission Exception.",
                                   "Invalid Token.",
                                   "Parameter Exception.",
                                   "Missing Parameters.",
                                   "Invalid Query.",
                                   "Sorry the Deezer Service is busy.",
                                   "There is no data"])
  }
  
  
  // ////////////////////// //
  // MARK: - VIEWMODEL TEST //
  // ////////////////////// //
  
  func testParsingPlaylistResults() throws {
    /// load mock json for playlist
    let mock = try loadMock(.playlists)
    /// convert file to data
    let json = try JSONSerialization.jsonObject(with: mock!, options: []) as! [String : Any]
    /// Time data to compare
    let intTime = 276
    /// Stores the result of the parsing method to test
    let playlist = viewModel.parsePlaylist(data: json)
    // Assertions for all properties
    XCTAssertEqual(playlist.count, 25)
    XCTAssertEqual(playlist[0].title, "- Ecouter Plus Tard")
    XCTAssertEqual(playlist[0].creator, "dadbond")
    XCTAssertEqual(playlist[0].duration,intTime.secondsToHoursMinutesSeconds() )
    XCTAssertEqual(playlist[0].smallPictureUrl,"https://e-cdns-images.dzcdn.net/images/cover/e5112921e0627e754ea1c1f6bbe137c3/250x250-000000-80-0-0.jpg")
    XCTAssertEqual(playlist[0].pictureUrl, "https://api.deezer.com/playlist/1549683151/image")
    XCTAssertEqual(playlist[0].trackList, "https://api.deezer.com/playlist/1549683151/tracks")
  }
  
  func testParsingTrackResults() throws {
    /// load mock json for tracklist
    let mock = try loadMock(.tracklists)
    /// Convert file to data
    let json = try JSONSerialization.jsonObject(with: mock!, options: []) as? [DeezerObject]
    /// Stores the result of the parsing method to test
    let tracks = viewModel.parseDeezerTracks(data: json!)
    // assertions
    XCTAssertEqual(tracks.count, 13)
  }
  
  
  func testLoadingPlaylists() throws {
    
    // Define expectations
    let expectOne = expectation(description: "playlist data is populated")
    let expectTwo = expectation(description: "first playlist is valid")
    let expectThree = expectation(description: "trackList is populated")
    let expectFour = expectation(description: "Server error is received")
    let expectFive = expectation(description: "Server error is received")
    /// number of track value to compare for test
    let expectedCount = 25
    /// mock title test to compare for test
    let expectedTitle = "#IWD la playlist d'HOLLYSIZ"
    
    /// property to check playlist loading
    var result: [Playlist]?
    
    // test Playlist Variable
    viewModel.playlistData.asObservable()
      .skip(1) // skip first dummy emitter
      .subscribe(onNext: {
        // grab data to test
        result = $0
        self.viewModel.selectedPlaylist.value = result![0]
        expectOne.fulfill()
      }).disposed(by: disposeBag)

    /// property to check tracklist variable
    var tracks: [Track]!
    // test TrackList Variable
    viewModel.tracklistData.asObservable()
      .skip(1)
      .subscribe {
        tracks = $0.element!
        expectTwo.fulfill()
      }.disposed(by: disposeBag)
    
    /// Mock Client for testing server internal Errors
    let deezerClient = DeezerApi(with: Constants.DevConfig.baseURL)
    /// property to check errorMessage variable
    var errorMessage: String?
    /// Test for server internal error
    _ = deezerClient.requestPlaylists(for: "-", parameters: nil).subscribe {
      switch $0 {
      case .success(let data):
        errorMessage = data.serverError
        expectThree.fulfill()
      case . error:
        break
      }
    }
    
    /// Mock Client for testing server connection Errors
    let testClient = DeezerApi(with:"")
    /// property to check errorMessage variable
    var errorMessage2: String?
    /// test for server connection errors
    _ = testClient.requestPlaylists(for: "-", parameters: nil).subscribe {
      switch $0 {
      case .success:
        break
      case . error(let error):
        errorMessage2 = error.localizedDescription
        expectFour.fulfill()
      }
    }
    
    /// property to check errorMessage variable
    var errorMessage3: String?
    /// test for Single connection errors
    _ = viewModel.serverError.asObservable().subscribe {
      errorMessage3 = $0.element
      expectFive.fulfill()
    }
    
    // Delay expectation and send error if delay is outdated
    waitForExpectations(timeout: 20.0) { error in
      guard error == nil else {
        XCTFail(error!.localizedDescription)
        return
      }
      
      // Assertions
      XCTAssertEqual(result?.count, expectedCount)
      XCTAssertEqual(result?[0].title, expectedTitle)
      XCTAssertEqual(tracks?.count, 20)
      XCTAssert(errorMessage != nil)
      XCTAssert(errorMessage2 != nil)
      XCTAssert(errorMessage3 != nil)
    }
  }
}




