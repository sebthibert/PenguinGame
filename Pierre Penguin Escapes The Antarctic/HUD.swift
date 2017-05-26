import SpriteKit

class HUD: SKNode {
  var textureAtlas = SKTextureAtlas(named:"HUD")
  var coinAtlas = SKTextureAtlas(named: "Environment")
  var heartNodes:[SKSpriteNode] = []
  let coinCountText = SKLabelNode(text: "000000")
  let restartButton = SKSpriteNode()
  let menuButton = SKSpriteNode()
  
  func createHudNodes(screenSize: CGSize) {
    let cameraOrigin = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
    let coinIcon = SKSpriteNode(texture: coinAtlas.textureNamed("coin-bronze"))
    let coinPosition = CGPoint(x: -cameraOrigin.x + 23, y: cameraOrigin.y - 23)
    coinIcon.size = CGSize(width: 26, height: 26)
    coinIcon.position = coinPosition
    coinCountText.fontName = "AvenirNext-HeavyItalic"
    let coinTextPosition = CGPoint(x: -cameraOrigin.x + 41, y: coinPosition.y)
    coinCountText.position = coinTextPosition
    coinCountText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    coinCountText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    self.addChild(coinCountText)
    self.addChild(coinIcon)
    
    for index in 0 ..< 3 {
      let newHeartNode = SKSpriteNode(texture: textureAtlas.textureNamed("heart-full"))
      newHeartNode.size = CGSize (width: 46, height: 40)
      let xPos = -cameraOrigin.x + CGFloat(index * 58) + 33
      let yPos = cameraOrigin.y - 66
      newHeartNode.position = CGPoint(x: xPos, y: yPos)
      heartNodes.append(newHeartNode)
      self.addChild(newHeartNode)
    }

    restartButton.texture = textureAtlas.textureNamed("button-restart")
    restartButton.name = "restartGame"
    restartButton.size = CGSize(width: 140, height: 140)
    menuButton.texture = textureAtlas.textureNamed("button-menu")
    menuButton.name = "returnToMenu"
    menuButton.size = CGSize(width: 70, height: 70)
    menuButton.position = CGPoint(x: -140, y: 0)
  }
  
  func setCoinCountDisplay(newCoinCount: Int) {
    let formatter = NumberFormatter()
    let number = NSNumber(value: newCoinCount)
    formatter.minimumIntegerDigits = 6
    if let coinStr = formatter.string(from: number) { coinCountText.text = coinStr }
  }
  
  func setHealthDisplay(newHealth: Int) {
    let fadeAction = SKAction.fadeAlpha(to: 0.2, duration: 0.3)
    for index in 0 ..< heartNodes.count {
      if index < newHealth {
        heartNodes[index].alpha = 1
      } else {
        heartNodes[index].run(fadeAction)
      }
    }
  }
  
  func showButtons() {
    restartButton.alpha = 0
    menuButton.alpha = 0
    self.addChild(restartButton)
    self.addChild(menuButton)
    let fadeAnimation = SKAction.fadeAlpha(to: 1, duration: 0.4)
    restartButton.run(fadeAnimation)
    menuButton.run(fadeAnimation)
  }
}
