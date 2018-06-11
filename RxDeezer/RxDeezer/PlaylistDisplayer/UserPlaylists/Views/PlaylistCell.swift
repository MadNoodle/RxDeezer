//
//  PlaylistCell.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 10/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import UIKit

class PlaylistCell: UICollectionViewCell {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureViews()
  }
  
  var thumbnailView : UIImageView = {
    let _thumbnailView = UIImageView()
    _thumbnailView.layer.cornerRadius = 20.0
    _thumbnailView.layer.masksToBounds = true
    // Preserve the image aspect ratio
    _thumbnailView.contentMode = .scaleAspectFill
    return _thumbnailView
  }()
  
  var titleLabel: UILabel = {
    let _titleLabel = UILabel()
    // customizing fonts
    _titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    // setting automatic line break
    _titleLabel.lineBreakMode = .byWordWrapping
    _titleLabel.numberOfLines = 0
    _titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return _titleLabel
  }()
  
  func configureViews() {
    self.addSubview(titleLabel)
    self.addSubview(thumbnailView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
