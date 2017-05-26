import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let menuScene = MenuScene()
    let skView = self.view as! SKView
    skView.ignoresSiblingOrder = true
    menuScene.size = view.bounds.size
    skView.presentScene(menuScene)
    
    if let musicPath = Bundle.main.path(forResource: "Sound/BackgroundMusic.m4a", ofType: nil) {
      let url = URL(fileURLWithPath: musicPath)
      
      do {
        musicPlayer = try AVAudioPlayer(contentsOf: url)
        musicPlayer.numberOfLoops = -1
        musicPlayer.prepareToPlay()
      } catch { /* Couldn't load music file */ }
    }
    
    if !muted { musicPlayer.play() }
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscape 
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
