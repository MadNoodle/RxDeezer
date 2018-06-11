//
//  TracksTableViewController.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 11/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import RxSwift

class TracksTableViewController: UITableViewController {
  var tracks = [Track]()
  let disposeBag = DisposeBag()
  
  let viewModel = PlaylistDisplayerViewModel.shared
    override func viewDidLoad() {
        super.viewDidLoad()
      // Load user's playlists
      // Grab trackList for the selected playlist
      viewModel.tracklistData.asObservable()
        .subscribe(onNext: { [weak self] audioTracks in
          self?.tracks = audioTracks
          for track in (self?.tracks)! {
            print("data tab : \(track.title)")
          }
          self?.tableView.reloadData()
        })
        .disposed(by: disposeBag)
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseId")
      tableView.delegate = self
      tableView.dataSource = self
      
  }

  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tracks.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseId", for: indexPath)

        cell.textLabel?.text = tracks[indexPath.row].title

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
