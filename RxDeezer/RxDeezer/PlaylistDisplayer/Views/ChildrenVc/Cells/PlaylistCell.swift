//
//  PlaylistCell.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 10/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import UIKit

/// Custom Collection View Cell that displays Playlist info
class PlaylistCell: UICollectionViewCell {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureViews()
  }
  
  /// Cover image
  var thumbnailView : UIImageView = {
    let _thumbnailView = UIImageView()
    // Rounded corners
    _thumbnailView.layer.cornerRadius = 20.0
    _thumbnailView.layer.masksToBounds = true
    // Preserve the image aspect ratio
    _thumbnailView.contentMode = .scaleAspectFill
    return _thumbnailView
  }()
  
  /// Playlist title label
  var titleLabel: UILabel = {
    let _titleLabel = UILabel()
    // customizing fonts
    _titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    // setting automatic line break
    _titleLabel.sizeToFit()
    _titleLabel.lineBreakMode = .byWordWrapping
    _titleLabel.numberOfLines = 0
    _titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return _titleLabel
  }()
  
  /// handle UISetup for cell
  func configureViews() {
    self.addSubview(titleLabel)
    self.addSubview(thumbnailView)
    // Set frame
    thumbnailView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.width)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
