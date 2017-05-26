//
//  GameViewController.swift
//  Pierre Penguin Escapes The Antarctic
//
//  Created by Sebastien Thibert on 24/05/2017.
//  Copyright © 2017 Sebastien Thibert. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    // Build the menu scene:
    let menuScene = MenuScene()
    let skView = self.view as! SKView
    // Ignore drawing order of child nodes
    // (This increases performance)
    skView.ignoresSiblingOrder = true
    // Size our scene to fit the view exactly:
    menuScene.size = view.bounds.size
    // Show the menu:
    skView.presentScene(menuScene)
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscape 
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
