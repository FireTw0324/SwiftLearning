//
//  BlankCover.swift
//  HelloMySecurity
//
//  Created by Kent Liu on 2020/12/23.
//

import UIKit

class BlankCover {
  
  private var coverVC: UIViewController?
  
  static let shared = BlankCover()
  private init() {
    
  }
  func showCover(window: UIWindow?) {
    
    // Don't show cover again.
    guard coverVC == nil else {
      return
    }
    
    coverVC = UIViewController()
    coverVC?.modalPresentationStyle = .fullScreen
    coverVC?.view.frame = UIScreen.main.bounds
    coverVC?.view.backgroundColor = .blue
    if let vc = coverVC {
      window?.visibleViewController?.present(vc, animated: false) // No animation!
    }
    
  }
  func hideCover() {
    coverVC?.dismiss(animated: false)
    coverVC = nil
  }
  
}

