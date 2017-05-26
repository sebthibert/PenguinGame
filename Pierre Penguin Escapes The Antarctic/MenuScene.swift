import SpriteKit

class MenuScene: SKScene {
  let textureAtlas = SKTextureAtlas(named:"HUD")
  let startButton = SKSpriteNode()
  
  override func didMove(to view: SKView) {
    self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    let backgroundImage = SKSpriteNode(imageNamed: "background-menu")
    backgroundImage.size = CGSize(width: 1024, height: 768)
    backgroundImage.zPosition = -1
    self.addChild(backgroundImage)
    
    let logoText = SKLabelNode(fontNamed: "AvenirNext-Heavy")
    logoText.text = "Pierre Penguin"
    logoText.position = CGPoint(x: 0, y: 100)
    logoText.fontSize = 60
    self.addChild(logoText)
    let logoTextBottom = SKLabelNode(fontNamed: "AvenirNext-Heavy")
    logoTextBottom.text = "Escapes the Antarctic"
    logoTextBottom.position = CGPoint(x: 0, y: 50)
    logoTextBottom.fontSize = 40
    self.addChild(logoTextBottom)
    
    startButton.texture = textureAtlas.textureNamed("button")
    startButton.size = CGSize(width: 295, height: 76)
    startButton.name = "StartBtn"
    startButton.position = CGPoint(x: 0, y: -20)
    self.addChild(startButton)
    
    let startText = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
    startText.text = "START GAME"
    startText.verticalAlignmentMode = .center
    startText.position = CGPoint(x: 0, y: 2)
    startText.fontSize = 40
    startText.name = "StartBtn"
    startText.zPosition = 5
    startButton.addChild(startText)
    
    let pulseAction = SKAction.sequence([
      SKAction.fadeAlpha(to: 0.5, duration: 0.9),
      SKAction.fadeAlpha(to: 1, duration: 0.9),
      ])
    
    startText.run(SKAction.repeatForever(pulseAction))
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in (touches) {
      let location = touch.location(in: self)
      let nodeTouched = atPoint(location)
      if nodeTouched.name == "StartBtn" {
        self.view?.presentScene(GameScene(size: self.size))
      }
    }
  }
}
