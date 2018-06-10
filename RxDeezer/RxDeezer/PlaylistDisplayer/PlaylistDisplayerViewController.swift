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
  
  let viewModel = PlaylistDisplayerViewModel(request: Constants.uniqueUserUrl)
  let disposeBag = DisposeBag()
  var playlists = [Playlist]()
  let offset: CGFloat = 60
  let reuseId = "cell"
  
  lazy var toolBar: UIView = {
    let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: offset)
    let _toolBar = UIView(frame: frame)
    let title = UILabel()
    title.frame = _toolBar.frame
    title.text = "Playlists"
    title.textAlignment = .center
    _toolBar.addSubview(title)
    
    return _toolBar
  }()
  
  lazy var collectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionFrame = CGRect(x: 0, y: offset, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - offset)
    let _collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
    _collectionView.backgroundColor = .white
    return _collectionView
  }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // parses playlists
      
      // parses tracks for playlists
      //viewModel.parse(urlRequest: "https://api.deezer.com/playlist/160504851/tracks", type: .tracklist)
      
      viewModel.playlistData.asObservable()
        .subscribe(onNext: { [weak self] userPlaylists in
          self?.playlists = userPlaylists
          self?.configureCollectionView()
        })
        .disposed(by: disposeBag)
      

    }

  func configureCollectionView() {
    self.view.addSubview(toolBar)
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
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let totalHeight: CGFloat = (self.view.frame.width / 3) + offset
    let totalWidth: CGFloat = (self.view.frame.width / 3)
    
    
    return CGSize(width: totalWidth, height: totalHeight)
  }
}

extension PlaylistDisplayerViewController: UICollectionViewDataSource, UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print(playlists.count)
    return playlists.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? PlaylistCell
    
    let currentPlaylist = playlists[indexPath.row]
    configure(cell, for: currentPlaylist)
 
    return cell!
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let currentPlaylist = playlists[indexPath.row]
    viewModel.parse(urlRequest: currentPlaylist.trackList, type: .tracklist)
    // binder la cell avec tracklist
    
  }

  func configure(_ cell: PlaylistCell?, for currentPlaylist: Playlist) {
    
    cell?.titleLabel.text = currentPlaylist.title
    cell?.titleLabel.frame = CGRect(x: 0, y: (cell?.contentView.frame.height)! - offset, width: (cell?.contentView.frame.width)!, height: offset)
    do {
      if let url = URL(string: currentPlaylist.smallPictureUrl){
        let data = try Data(contentsOf: url)
        cell?.thumbnailView.image = UIImage(data: data)
        
      }
    }
    catch{
      print(error)
    }
    cell?.thumbnailView.frame = CGRect(x: 0, y: 0, width: (cell?.contentView.frame.width)!, height: (cell?.contentView.frame.width)!)
  }
 
}
