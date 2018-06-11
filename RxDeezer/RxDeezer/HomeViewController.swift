//
//  HomeViewController.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 11/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController, UIScrollViewDelegate {
  
  lazy var scrollView: UIScrollView = {
    let view = UIScrollView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentSize.height = UIScreen.main.bounds.height * 2 + 30
    view.backgroundColor = .white
    return view
  }()
  
  
  lazy var playlistHeader : UIImageView = {
    let _playlistHeader = UIImageView()
    _playlistHeader.translatesAutoresizingMaskIntoConstraints = false
    
    // add image
    _playlistHeader.image = UIImage(named: "Yoda.jpg")
    // preserve aspect Ratio
    _playlistHeader.contentMode = .scaleAspectFill
    // add shadow
    _playlistHeader.layer.shadowColor = UIColor.black.cgColor
    _playlistHeader.layer.shadowOffset = CGSize(width: 0, height: -2)
    _playlistHeader.layer.shadowRadius = 2
    _playlistHeader.layer.shadowOpacity = 0.3
    return _playlistHeader
  }()
  
  lazy var playlistTitle: UILabel = {
    let _titleLabel = UILabel()
    _titleLabel.text = "Playlist Title"
    // customizing fonts
    _titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    // setting automatic line break
    _titleLabel.lineBreakMode = .byWordWrapping
    _titleLabel.numberOfLines = 0
    _titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return _titleLabel
  }()
  
  lazy var playlistDuration: UILabel = {
    let _playlistDuration = UILabel()
    _playlistDuration.text = "Duration : 00h45m00s"
    // customizing fonts
    _playlistDuration.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
    // setting automatic line break
    _playlistDuration.lineBreakMode = .byWordWrapping
    _playlistDuration.numberOfLines = 0
    _playlistDuration.translatesAutoresizingMaskIntoConstraints = false
    return _playlistDuration
  }()

  lazy var playlistCreator: UILabel = {
    let _playlistCreator = UILabel()
    _playlistCreator.text = "Owner: Michel Platini"
    _playlistCreator.textAlignment = .right
    // customizing fonts
    _playlistCreator.font = UIFont.systemFont(ofSize: 12, weight: .light)
    // setting automatic line break
    _playlistCreator.lineBreakMode = .byWordWrapping
    _playlistCreator.numberOfLines = 0
    _playlistCreator.translatesAutoresizingMaskIntoConstraints = false
    return _playlistCreator
  }()

  var tracks = [Track]()
  let viewModel = PlaylistDisplayerViewModel.shared
  let playlistCollectionController = PlaylistDisplayerViewController()
  let disposeBag = DisposeBag()
  // MARK: - LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    playlistCollectionController.selectedPlaylist?.subscribe(onNext: { [weak self] playlist in
      self?.playlistHeader.load(urlString: playlist.smallPictureUrl)
      self?.playlistTitle.text = playlist.title
      self?.playlistCreator.text = playlist.creator
      self?.playlistDuration.text = playlist.duration
    }).disposed(by: disposeBag)
    // Grab trackList for the selected playlist
    viewModel.tracklistData.asObservable()
      .subscribe(onNext: { [weak self] audioTracks in
        self?.tracks = audioTracks
        for track in (self?.tracks)! {
          print("data recu : \(track.title)")
        }
      })
      .disposed(by: disposeBag)
    
    
    view.addSubview(scrollView)
    setupScrollView()
  }

  func setupScrollView(){
    
    // ScrollView Constraints
    scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    
    // Playlist Collection Container
    let collectionContainer = UIView()
    collectionContainer.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(collectionContainer)
    
    // Constraints
    collectionContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    collectionContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
    collectionContainer.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width - 40 ).isActive = true
    collectionContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height ).isActive = true
   
        // add child view controller view to container
    
    let playlistCollectionController = PlaylistDisplayerViewController()
    playlistCollectionController.embed(to: self, in: collectionContainer)
    

    // MARK: - HEADERVIEW LABEL SETUP
 
    scrollView.addSubview(playlistHeader)
    // Constraints
    playlistHeader.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    playlistHeader.topAnchor.constraint(equalTo: collectionContainer.bottomAnchor, constant: 40).isActive = true
    playlistHeader.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width).isActive = true
    playlistHeader.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
    // MARK: - TITLE LABEL SETUP
    
    scrollView.addSubview(playlistTitle)
    // Constraints
    playlistTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    playlistTitle.topAnchor.constraint(equalTo: playlistHeader.bottomAnchor, constant: 24).isActive = true
    playlistTitle.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width - 40).isActive = true
    playlistTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    // MARK: - DURATION LABEL SETUP
    
    scrollView.addSubview(playlistDuration)
    // Constraints
    playlistDuration.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    playlistDuration.topAnchor.constraint(equalTo: playlistTitle.bottomAnchor).isActive = true
    playlistDuration.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width - 40).isActive = true
    playlistDuration.heightAnchor.constraint(equalToConstant: 16).isActive = true
    
    // MARK: - CREATOR LABEL SETUP
    
    scrollView.addSubview(playlistCreator)
    // Constraints
    playlistCreator.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    playlistCreator.topAnchor.constraint(equalTo: playlistDuration.bottomAnchor, constant: 16).isActive = true
    playlistCreator.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width - 40).isActive = true
    playlistCreator.heightAnchor.constraint(equalToConstant: 16).isActive = true
    
    // MARK: - TRACKSTABLE LABEL SETUP
    let tracksTable = UIView()
    tracksTable.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(tracksTable)
    // Constraints
    tracksTable.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    tracksTable.topAnchor.constraint(equalTo: playlistCreator.bottomAnchor, constant: 16).isActive = true
    tracksTable.widthAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width - 40).isActive = true
    tracksTable.heightAnchor.constraint(equalToConstant: 300).isActive = true
    
    let tracklistTableController = TracksTableViewController()
    tracklistTableController.embed(to: self, in: tracksTable)
  }
  
 
  
  
}
