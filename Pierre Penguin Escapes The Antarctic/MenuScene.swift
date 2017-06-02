import SpriteKit

class MenuScene: SKScene {
  let textureAtlas = SKTextureAtlas(named:"HUD")
  let startButton = SKSpriteNode()
  let muteButton = SKSpriteNode()
  
  override func didMove(to view: SKView) {
    self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    let backgroundImage = SKSpriteNode(imageNamed: "background-menu")
    backgroundImage.size = CGSize(width: 1024, height: 768)
    backgroundImage.zPosition = -1
    self.addChild(backgroundImage)
    
    let logoText = SKLabelNode(fontNamed: font)
    logoText.text = "Pierre Penguin"
    logoText.position = CGPoint(x: 0, y: 100)
    logoText.fontSize = fontSizeLarge
    self.addChild(logoText)
    let logoTextBottom = SKLabelNode(fontNamed: font)
    logoTextBottom.text = "Escapes the Antarctic"
    logoTextBottom.position = CGPoint(x: 0, y: 50)
    logoTextBottom.fontSize = fontSizeMedium
    self.addChild(logoTextBottom)
    
    if muted { muteButton.texture = textureAtlas.textureNamed("button-unmute") }
    if !muted { muteButton.texture = textureAtlas.textureNamed("button-mute") }
    muteButton.size = CGSize(width: 50, height: 50)
    muteButton.name = "MuteButton"
    muteButton.position = CGPoint(x: 0, y: -100)
    self.addChild(muteButton)
    
    startButton.texture = textureAtlas.textureNamed("button")
    startButton.size = CGSize(width: 295, height: 76)
    startButton.name = "StartButton"
    startButton.position = CGPoint(x: 0, y: -20)
    self.addChild(startButton)
    
    let startText = SKLabelNode(fontNamed: font)
    startText.text = "START GAME"
    startText.verticalAlignmentMode = .center
    startText.position = CGPoint(x: 0, y: 2)
    startText.fontSize = fontSizeMedium
    startText.name = "StartButton"
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
      
      if nodeTouched.name == "StartButton" {
        self.view?.presentScene(GameScene(size: self.size))
      } else if nodeTouched.name == "MuteButton" {
        if muted {
          muteButton.texture = textureAtlas.textureNamed("button-mute")
          musicPlayer.play()
          muted = false
        } else {
          muteButton.texture = textureAtlas.textureNamed("button-unmute")
          musicPlayer.pause()
          muted = true
        }
      }
    }
  }
}
