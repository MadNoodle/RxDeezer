//
//  HomeViewController.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 11/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import RxSwift

///
/// Root View Controller that contains 3 containers embedded in A UIScrollView
/// Functionnalities:
/// - Present User's playlist in a 3 columns collection
/// - Allow the user to discover a summary of each playlist on celltap
/// - Display Tracklist incl. title - artist - duration
///
class HomeViewController: UIViewController, UIScrollViewDelegate {
  
  // MARK: - UI CONTAINERS
  
  /// ScrollView that contains the whole navigation
  lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentSize.height = UIScreen.main.bounds.height * 2 + 30
    view.backgroundColor = .white
    return view
  }()
  
 
  /// Playlists CollectionView controller container
  let collectionContainer: UIView = {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    return container
  }()
 
  /// Playlist header that presents: Title, thumbnail, duration & creator
  lazy var playlistHeader : UIView = {
    let _playlistHeader = UIView()
    _playlistHeader.translatesAutoresizingMaskIntoConstraints = false
    _playlistHeader.backgroundColor = Constants.DevConfig.complementaryColor
    // add shadow
    _playlistHeader.layer.shadowColor = UIColor.black.cgColor
    _playlistHeader.layer.shadowOffset = CGSize(width: 0, height: -2)
    _playlistHeader.layer.shadowRadius = 2
    _playlistHeader.layer.shadowOpacity = 0.3
    return _playlistHeader
  }()
  
  
  /// Tracks TableView ChildController container
  let tracksTable: UIView = {
    let container = UIView()
    container.backgroundColor = Constants.DevConfig.complementaryColor
    container.translatesAutoresizingMaskIntoConstraints = false
    return container
  }()
  
  // MARK: - UI ELEMENTS
  
  /// Playlist thumbnailCover Image
  lazy var thumbnail: UIImageView = {
    let _thumbnail = UIImageView()
    _thumbnail.translatesAutoresizingMaskIntoConstraints = false
    _thumbnail.contentMode = .scaleAspectFill
    _thumbnail.layer.cornerRadius = 20.0
    _thumbnail.layer.masksToBounds = true
    // add shadow
    _thumbnail.layer.shadowColor = UIColor.black.cgColor
    _thumbnail.layer.shadowOffset = CGSize(width: 2, height: 2)
    _thumbnail.layer.shadowRadius = 2
    _thumbnail.layer.shadowOpacity = 0.3
    return _thumbnail
  }()
  
  
  /// Playlist Title
  lazy var playlistTitle: UILabel = {
    let _titleLabel = UILabel()
    
    // customizing fonts
    _titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    _titleLabel.textColor = .white
    _titleLabel.sizeToFit()
    _titleLabel.textAlignment = .right
    // setting automatic line break
    _titleLabel.lineBreakMode = .byWordWrapping
    _titleLabel.numberOfLines = 0
    _titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return _titleLabel
  }()
  
  /// Playlist total duration format hh:mm:ss
  lazy var playlistDuration: UILabel = {
    let _playlistDuration = UILabel()
    
    // customizing fonts
    _playlistDuration.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
    _playlistDuration.textColor = .white
    _playlistDuration.textAlignment = .right
    // setting automatic line break
    _playlistDuration.lineBreakMode = .byWordWrapping
    _playlistDuration.numberOfLines = 0
    _playlistDuration.translatesAutoresizingMaskIntoConstraints = false
    return _playlistDuration
  }()
  
  /// Playlist's owner
  lazy var playlistCreator: UILabel = {
    let _playlistCreator = UILabel()
    // paragraph style
    _playlistCreator.textAlignment = .right
    // customizing fonts
    _playlistCreator.font = UIFont.systemFont(ofSize: 12, weight: .light)
    _playlistCreator.textColor = .white
    // setting automatic line break
    _playlistCreator.lineBreakMode = .byWordWrapping
    _playlistCreator.numberOfLines = 0
    _playlistCreator.translatesAutoresizingMaskIntoConstraints = false
    return _playlistCreator
  }()
  
  // MARK: - SCROLL PROPERTIES
  let treshold: CGFloat = 35
  let stepZero = CGPoint(x: 0, y: 20)
  let stepOne = CGPoint(x: 0, y: 220)
  let stepTwo = CGPoint(x: 0, y: 680)
  let scrollState = Variable<CGFloat>(0)
  
  // MARK DATA PROPERTIES
  let viewModel = PlaylistDisplayerViewModel.shared
  var tracks = [Track]()
  let playlistCollectionController = PlaylistDisplayerViewController()
  let disposeBag = DisposeBag()
  

  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    configureDataBindings()
    view.addSubview(scrollView)
    setupScrollView()
   
    // Check for internet access
    if RxReachability.shared.startMonitor(Constants.DevConfig.baseURL){

      // init Deezer Services
      configureUIBinding()
      
    } else {
      //Displays an alert if device is not connected to internet
      let alert  = UIAlertController(title: "Warning",
                                     message: "Please connect to the internet to have access to this service",
                                     preferredStyle: .alert)
      self.present(alert, animated: true)
    }
  }

  /// Initialize subscription to retrieve data from View Model
  private func configureDataBindings() {
    // Update HeaderView with currently selected playlist info
    viewModel.selectedPlaylist.asObservable().subscribe(onNext: { [weak self] playlist in
      self?.thumbnail.load(urlString: playlist.smallPictureUrl)
      self?.playlistTitle.text = playlist.title.uppercased()
      self?.playlistCreator.text = "creator: \(playlist.creator)"
      self?.playlistDuration.text = "Duration: \(playlist.duration)"
      self?.scrollView.setContentOffset((self?.stepOne)!, animated: true)
    }).disposed(by: disposeBag)
    
    // Retrieve tracks info for trackList associated with currently selected playlist
    viewModel.tracklistData.asObservable()
      .subscribe(onNext: { [weak self] audioTracks in
        self?.tracks = audioTracks
      })
      .disposed(by: disposeBag)
    
    // listen to connections errors
    
    viewModel.serverError.asObservable().subscribe(onNext: {[weak self] errorMessage in
      UserAlert.show(title: "Error", message: errorMessage, controller: self!)
      
    }).disposed(by: disposeBag)
  }
  
  // MARK: - SCROLL SETUP
  
  /// Configure Binding for scrollContentOffset value to enable
  /// user to scroll and autoscroll to original offset
  private func configureUIBinding() {
    // Skip(1) prevent a sligth contentoffset bug
    scrollState.asObservable().skip(1).subscribe (onNext: {[weak self] value in
      self?.autoScroll()
      }
      ).disposed(by: disposeBag)
  }
  
  /// Handles All UISetup for the app
  private func setupScrollView() {
    // UI Setup
    setupSubViews()
    setupConstraints()
    // ScrollView scrolling
    scrollView.delegate = self
    self.scrollView.isScrollEnabled = false
    // Reset contentOffset
    scrollView.contentOffset = stepZero
    
    // add child view controller view to containers
    let playlistCollectionController = PlaylistDisplayerViewController()
    playlistCollectionController.embed(to: self, in: collectionContainer)
    let tracklistTableController = TracksTableViewController()
    tracklistTableController.embed(to: self, in: tracksTable)
   
  }
  
  /// Delegate method to handle behavior associated with scroll
  ///
  /// - Parameter scrollView: UIScrollView
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Assign contentoffset Y value to Variable<CGFloat> scrollState
    // this value is used by autoScroll()
    scrollState.value = scrollView.contentOffset.y
    scrollView.setNeedsLayout()
    collectionContainer.setNeedsLayout()
    
  }
  
  private func autoScroll() {
    // Bounce back to initial position if user scroll up when on Playlist header
    if scrollView.isScrollEnabled && scrollView.contentOffset.y <= (playlistHeader.frame.height - treshold) {
      scrollView.setContentOffset(stepZero, animated: true)
      scrollView.isScrollEnabled = false
      tracksTable.isUserInteractionEnabled = false
      
      // Sets status bar to black color
      UIApplication.shared.statusBarStyle = .default
    } else if scrollView.contentOffset.y > (playlistHeader.frame.height - treshold) {
      // set status bar to white over blue on header
      UIApplication.shared.statusBarStyle = .lightContent
      scrollView.isScrollEnabled = true
      tracksTable.isUserInteractionEnabled = true
    }
  }
 
  // MARK: - UI SETUP
  /// Add Subviews in main scrollView container
  fileprivate func setupSubViews() {
    // set containers
    scrollView.addSubview(collectionContainer)
    scrollView.addSubview(playlistHeader)
    scrollView.addSubview(tracksTable)
   
    // Nest subviews in header
    playlistHeader.addSubview(thumbnail)
    playlistHeader.addSubview(playlistTitle)
    playlistHeader.addSubview(playlistDuration)
    playlistHeader.addSubview(playlistCreator)
  }
  
  /// Handles all contraints for all views using Anchor system
  private func setupConstraints() {
    // ScrollView Constraints
    scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    
    // COLLECTION Constraints
    collectionContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    collectionContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
    collectionContainer.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width - 40 ).isActive = true
    collectionContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height ).isActive = true
    
    // HEADER Constraints
    playlistHeader.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    playlistHeader.topAnchor.constraint(equalTo: collectionContainer.bottomAnchor).isActive = true
    playlistHeader.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width).isActive = true
    playlistHeader.heightAnchor.constraint(equalToConstant: 200).isActive = true

    // TABLE Constraints
    tracksTable.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    tracksTable.topAnchor.constraint(equalTo: playlistHeader.bottomAnchor, constant: 16).isActive = true
    tracksTable.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width - 40).isActive = true
    tracksTable.heightAnchor.constraint(equalToConstant: 400).isActive = true
    
    // THUMBNAIL Constraints
    
    thumbnail.leadingAnchor.constraint(equalTo: playlistHeader.leadingAnchor, constant: 20).isActive = true
    thumbnail.topAnchor.constraint(equalTo: playlistHeader.topAnchor, constant: 20).isActive = true
    thumbnail.widthAnchor.constraint(equalToConstant: 160).isActive = true
    thumbnail.heightAnchor.constraint(equalToConstant: 160).isActive = true
    
    // TITLE LABEL Constraints
    playlistTitle.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 16).isActive = true
    playlistTitle.trailingAnchor.constraint(equalTo: playlistHeader.trailingAnchor, constant: -16).isActive = true
    playlistTitle.topAnchor.constraint(equalTo: playlistHeader.topAnchor, constant: 20).isActive = true
    
    // DURATION LABEL Constraints
    playlistDuration.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 16).isActive = true
    playlistDuration.topAnchor.constraint(equalTo: playlistTitle.bottomAnchor, constant: 20).isActive = true
    playlistDuration.trailingAnchor.constraint(equalTo: playlistHeader.trailingAnchor, constant: -16).isActive = true
    playlistDuration.heightAnchor.constraint(equalToConstant: 16).isActive = true
  
    
    // CREATOR Constraints
    if #available(iOS 11.0, *) {
      playlistCreator.topAnchor.constraintGreaterThanOrEqualToSystemSpacingBelow(playlistDuration.bottomAnchor, multiplier: 16)
    } else {
      // Fallback on earlier
      playlistCreator.topAnchor.constraint(greaterThanOrEqualTo: playlistDuration.bottomAnchor, constant: 16)
    }
    
    playlistCreator.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 16).isActive = true
    playlistCreator.bottomAnchor.constraint(equalTo: playlistHeader.bottomAnchor, constant: -16).isActive = true
    playlistCreator.trailingAnchor.constraint(equalTo: playlistHeader.trailingAnchor, constant: -16).isActive = true
    playlistCreator.heightAnchor.constraint(equalToConstant: 16).isActive = true
  }
  
}
