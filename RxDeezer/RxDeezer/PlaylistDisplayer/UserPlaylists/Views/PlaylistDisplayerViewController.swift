//
//  PlaylistDisplayerViewController.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 09/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import RxSwift


class PlaylistDisplayerViewController: UIViewController {
  
  // MARK: - DATA PROPERTIES
  
  /// Common View Model Instance to fetch and exchange data
  let viewModel = PlaylistDisplayerViewModel.shared
  /// Gather observable Disposables and dealloc them when needed
  let disposeBag = DisposeBag()
  /// Array that stores Playlist before displaying them in collection
  var playlists = [Playlist]()
  /// Variable used to emit data when user select a playlist
  var trackList = Variable<String?>("")
  
  // MARK: - UI PROPERTIES
  let offset: CGFloat = 60
  let reuseId = "cell"
  
  // MARK: - OUTLETS
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
  
  
  // MARK: - VIEW LIFECYCLE METHODS
  override func viewDidLoad() {
    super.viewDidLoad()
    configureDataBinding()
  }
  
  /// Initiate listening to ViewModel Variable to fetch data from remote server( Deezer)
  func configureDataBinding() {
    // Load user's playlists
    viewModel.playlistData.asObservable()
      .subscribe(onNext: { [weak self] userPlaylists in
        self?.playlists = userPlaylists
        self?.configureCollectionView()
      })
      .disposed(by: disposeBag)
  }
  
  /// handle collection view setup ( delegation, datasource, UI)
  func configureCollectionView() {
    self.view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: reuseId)
    collectionView.reloadData()
  }
  
  
}

// MARK: - FLOW LAYOUT DELEGATE
extension PlaylistDisplayerViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets.zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let totalHeight: CGFloat = (self.view.frame.width / 3) + offset - 1
    let totalWidth: CGFloat = (self.view.frame.width / 3) - 1
    return CGSize(width: totalWidth, height: totalHeight)
  }
  
}

// MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE METHODS
extension PlaylistDisplayerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return playlists.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // load custom cell
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? PlaylistCell
    // fetch and display data
    let currentPlaylist = playlists[indexPath.row]
    configure(cell, for: currentPlaylist)
    return cell!
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // Assign a new Value to View Model Variable<Playlist> for current playlist
    viewModel.selectedPlaylist.value = playlists[indexPath.row]
  }
  
  
  func configure(_ cell: PlaylistCell?, for currentPlaylist: Playlist) {
    
    cell?.titleLabel.text = currentPlaylist.title
    cell?.titleLabel.frame = CGRect(x: 0, y: (cell?.contentView.frame.height)! - offset, width: (cell?.contentView.frame.width)!, height: offset)
    // Load and cache Cover image
    cell?.thumbnailView.load(urlString: currentPlaylist.smallPictureUrl)
    // Customize thumbnail frame size in collection size
    
  }
  
}
