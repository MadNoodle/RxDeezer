//
//  PlaylistDisplayerViewController.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 09/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

class PlaylistDisplayerViewController: UIViewController {
  
  let viewModel = PlaylistDisplayerViewModel.shared // Refactor pour ne pas avoir besoin de rentrer un user et le mettre dans une constante
  let disposeBag = DisposeBag()
  var playlists = [Playlist]()
  var tracks = [Track]()
  var selectedPlaylist: Observable<Playlist>?
  let offset: CGFloat = 60
  let reuseId = "cell"
  var trackList = Variable<String?>("")
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var buttonContainer: UIView!
  @IBOutlet weak var buttonHeigth: NSLayoutConstraint!
  @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureDataBinding()
  }
  
  func configureDataBinding() {
    
    // Load user's playlists
    viewModel.playlistData.asObservable()
      .subscribe(onNext: { [weak self] userPlaylists in
        self?.playlists = userPlaylists
        self?.configureCollectionView()
      })
      .disposed(by: disposeBag)
    
    
  }
  
  func configureCollectionView() {
    self.view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: reuseId)
    collectionView.reloadData()
  }
  
  
}

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

extension PlaylistDisplayerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return playlists.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? PlaylistCell
    
    let currentPlaylist = playlists[indexPath.row]
    configure(cell, for: currentPlaylist)
    
    return cell!
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // Send selected playlist tracklist url to viewModel
    viewModel.tracklistUrl.value = playlists[indexPath.row].trackList
    selectedPlaylist = Observable<Playlist>.just(playlists[indexPath.row])
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    collectionViewBottomConstraint.constant = 0
  }
  
  func configure(_ cell: PlaylistCell?, for currentPlaylist: Playlist) {
    
    cell?.titleLabel.text = currentPlaylist.title
    cell?.titleLabel.frame = CGRect(x: 0, y: (cell?.contentView.frame.height)! - offset, width: (cell?.contentView.frame.width)!, height: offset)
   
        cell?.thumbnailView.load(urlString: currentPlaylist.smallPictureUrl)
        
    
    cell?.thumbnailView.frame = CGRect(x: 0, y: 0, width: (cell?.contentView.frame.width)!, height: (cell?.contentView.frame.width)!)
  }
  
}