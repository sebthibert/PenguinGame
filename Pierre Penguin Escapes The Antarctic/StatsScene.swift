import SpriteKit

class StatsScene: SKScene {
  let textureAtlas = SKTextureAtlas(named:"HUD")
  let coinAtlas = SKTextureAtlas(named:"Environment")
  let backButton = SKSpriteNode()
  
  override func didMove(to view: SKView) {
    self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    let backgroundImage = SKSpriteNode(imageNamed: "background-menu")
    backgroundImage.size = CGSize(width: 1024, height: 768)
    backgroundImage.zPosition = -1
    self.addChild(backgroundImage)
    
    backButton.texture = textureAtlas.textureNamed("button-back")
    backButton.name = "backToEndScene"
    backButton.size = CGSize(width: 140, height: 140)
    backButton.position = CGPoint(x: 0, y: -50)
    self.addChild(backButton)
    
    let scoreText = SKLabelNode(fontNamed: font)
    let highestScore = UserDefaults.standard.object(forKey: "HighScore") as? CGFloat ?? 0
    scoreText.text = "Highscore: " + String(Int(highestScore))
    scoreText.position = CGPoint(x: 0, y: 100)
    scoreText.fontSize = fontSizeMedium
    self.addChild(scoreText)
    
    let coinIcon = SKSpriteNode(texture: coinAtlas.textureNamed("coin-gold"))
    coinIcon.size = CGSize(width: 35, height: 35)
    coinIcon.position = CGPoint(x: (scoreText.frame.minX + (coinIcon.frame.width/2)), y: 65)
    self.addChild(coinIcon)
    
    let coinText = SKLabelNode(fontNamed: font)
    let highestCoinsCollected = UserDefaults.standard.object(forKey: "HighCoinsCollected") as? Int ?? 0
    coinText.text = String(highestCoinsCollected)
    coinText.position = CGPoint(x: coinIcon.frame.maxX + 25 + (coinText.frame.width/2), y: 50)
    coinText.fontSize = fontSizeMedium
    self.addChild(coinText)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in (touches) {
      let location = touch.location(in: self)
      let nodeTouched = atPoint(location)
      
      if nodeTouched.name == "backToEndScene" {
        self.view?.presentScene(EndScene(size: self.size), transition: .crossFade(withDuration: 0.6))
      }
    }
  }
}
