//
//  extensionUIView+Embed.swift
//  RxDeezer
//
//  Created by Mathieu Janneau on 11/06/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  
  // add child view controller view to container
  func embed(to parentController: UIViewController, in container : UIView){
  
  parentController.addChildViewController(self)
  self.view.translatesAutoresizingMaskIntoConstraints = false
  container.addSubview(self.view)
  
  NSLayoutConstraint.activate([
  self.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
  self.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
  self.view.topAnchor.constraint(equalTo: container.topAnchor),
  self.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
  ])
  
  self.didMove(toParentViewController: self)}
}
