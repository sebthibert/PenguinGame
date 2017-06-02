import SpriteKit

class EndScene: SKScene {
  let textureAtlas = SKTextureAtlas(named:"HUD")
  let coinAtlas = SKTextureAtlas(named:"Environment")
  let statsButton = SKSpriteNode()
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
    restartButton.position = CGPoint(x: 0, y: -50)
    menuButton.texture = textureAtlas.textureNamed("button-menu")
    menuButton.name = "returnToMenu"
    menuButton.size = CGSize(width: 70, height: 70)
    menuButton.position = CGPoint(x: -140, y: -50)
    self.addChild(restartButton)
    self.addChild(menuButton)
    
    statsButton.texture = textureAtlas.textureNamed("button-stats")
    statsButton.size = CGSize(width: 70, height: 70)
    statsButton.name = "showStats"
    statsButton.position = CGPoint(x: 140, y: -50)
    self.addChild(statsButton)
    
    let scoreText = SKLabelNode(fontNamed: font)
    scoreText.text = "Score: " + String(Int(playerProgress / 100))
    scoreText.position = CGPoint(x: 0, y: 100)
    scoreText.fontSize = fontSizeMedium
    self.addChild(scoreText)
    
    let coinIcon = SKSpriteNode(texture: coinAtlas.textureNamed("coin-gold"))
    coinIcon.size = CGSize(width: 35, height: 35)
    coinIcon.position = CGPoint(x: (scoreText.frame.minX + (coinIcon.frame.width/2)), y: 65)
    self.addChild(coinIcon)
    
    let coinText = SKLabelNode(fontNamed: font)
    coinText.text = String(coinsCollected)
    coinText.position = CGPoint(x: coinIcon.frame.maxX + 25 + (coinText.frame.width/2), y: 50)
    coinText.fontSize = fontSizeMedium
    self.addChild(coinText)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in (touches) {
      let location = touch.location(in: self)
      let nodeTouched = atPoint(location)
      
      if nodeTouched.name == "restartGame" {
        self.view?.presentScene(GameScene(size: self.size), transition: .crossFade(withDuration: 0.4))
      } else if nodeTouched.name == "returnToMenu" {
        self.view?.presentScene(MenuScene(size: self.size), transition: .crossFade(withDuration: 0.4))
      } else if nodeTouched.name == "showStats" {
        self.view?.presentScene(StatsScene(size: self.size), transition: .crossFade(withDuration: 0.4))
      }
    }
  }
}
