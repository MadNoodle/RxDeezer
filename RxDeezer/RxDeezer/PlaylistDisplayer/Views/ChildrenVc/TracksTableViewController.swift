//
//  TracksTableViewController.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 11/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import RxSwift

/**
 TableView to display trackList. Will be lazy loaded on scroll
 in the homeViewcontroller
 */
class TracksTableViewController: UITableViewController {
  
  // ///////////////// //
  // MARK : PROPERTIES //
  // ///////////////// //
  
  /// Rx swift bag to store disposables and deallocated them
  let disposeBag = DisposeBag()
  /// Intantiate ViewModel
  let viewModel = PlaylistDisplayerViewModel.shared
  /// Properties to store Tracks and load datasource in tableVeiw
  var tracks = [Track]()
  /// Custom cell reusable id
  let reuseId = "reuseId"
  
  // //////////////////////// //
  // MARK: - LIFECYCLE METHOD //
  // //////////////////////// //
  
  override func viewDidLoad() {
        super.viewDidLoad()
      configureTableview()
      configureDataBinding()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  
  // //////////////////// //
  // MARK: - DATA METHODS //
  // //////////////////// //
  
  /// Start observing ViewModel
  func configureDataBinding() {
    // Load user's playlists tracks
    viewModel.tracklistData.asObservable()
      .subscribe(onNext: { [weak self] audioTracks in
        self?.tracks = audioTracks
        self?.tableView.reloadData()
      })
      .disposed(by: disposeBag)
  }
  
  /// Set tableViewdelegation and custom cell
  func configureTableview() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "TrackCell", bundle: nil), forCellReuseIdentifier: reuseId)
  }
    // ////////////////////////////// //
    // MARK: - Table view data source //
    // ////////////////////////////// //
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as? TrackCell

        cell?.titleLabel.text = tracks[indexPath.row].title
        cell?.artistLabel.text = tracks[indexPath.row].artist
        cell?.durationLabel.text = tracks[indexPath.row].duration.secondsToHoursMinutesSeconds()
      
        return cell!
    }
 

}
