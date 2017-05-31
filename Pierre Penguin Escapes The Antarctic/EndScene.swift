import SpriteKit

class EndScene: SKScene {
  let textureAtlas = SKTextureAtlas(named:"HUD")
  let restartButton = SKSpriteNode()
  let menuButton = SKSpriteNode()
  
  override func didMove(to view: SKView) {
    self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    let backgroundImage = SKSpriteNode(imageNamed: "background-menu")
    backgroundImage.size = CGSize(width: 1024, height: 768)
    backgroundImage.zPosition = -1
    self.addChild(backgroundImage)
    
    restartButton.texture = textureAtlas.textureNamed("button-restart")
    restartButton.name = "restartGame"
    restartButton.size = CGSize(width: 140, height: 140)
    menuButton.texture = textureAtlas.textureNamed("button-menu")
    menuButton.name = "returnToMenu"
    menuButton.size = CGSize(width: 70, height: 70)
    menuButton.position = CGPoint(x: -140, y: 0)
    self.addChild(restartButton)
    self.addChild(menuButton)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in (touches) {
      let location = touch.location(in: self)
      let nodeTouched = atPoint(location)
      
      if nodeTouched.name == "restartGame" {
        self.view?.presentScene(GameScene(size: self.size), transition: .crossFade(withDuration: 0.6))
      } else if nodeTouched.name == "returnToMenu" {
        self.view?.presentScene(MenuScene(size: self.size), transition: .crossFade(withDuration: 0.6))
      }
    }
  }
}
