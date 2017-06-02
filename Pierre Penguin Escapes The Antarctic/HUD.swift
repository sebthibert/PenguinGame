import SpriteKit

class HUD: SKNode {
  var textureAtlas = SKTextureAtlas(named:"HUD")
  var coinAtlas = SKTextureAtlas(named: "Environment")
  var heartNodes:[SKSpriteNode] = []
  let coinCountText = SKLabelNode(text: "0")
  let scoreLabel = SKLabelNode(text: "Score: ")
  let scoreCountText = SKLabelNode(text: "0")
  let pauseButton = SKSpriteNode()
  let playButton = SKSpriteNode()
  
  func createHudNodes(screenSize: CGSize) {
    let cameraOrigin = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
    let coinIcon = SKSpriteNode(texture: coinAtlas.textureNamed("coin-gold"))
    let coinPosition = CGPoint(x: -cameraOrigin.x + 23, y: cameraOrigin.y - 45)
    coinIcon.size = CGSize(width: 26, height: 26)
    coinIcon.position = coinPosition
    coinCountText.fontName = font
    coinCountText.fontSize = fontSizeSmall
    let coinTextPosition = CGPoint(x: -cameraOrigin.x + 41, y: coinPosition.y)
    coinCountText.position = coinTextPosition
    coinCountText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    coinCountText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    self.addChild(coinCountText)
    self.addChild(coinIcon)
    
    pauseButton.texture = textureAtlas.textureNamed("button-pause")
    playButton.texture = textureAtlas.textureNamed("button-play")
    pauseButton.name = "pauseGame"
    playButton.name = "playGame"
    pauseButton.size = CGSize(width: 20, height: 25)
    playButton.size = CGSize(width: 25, height: 25)
    pauseButton.position = CGPoint(x: -cameraOrigin.x + 630, y: cameraOrigin.y - 30)
    playButton.position = CGPoint(x: -cameraOrigin.x + 635, y: cameraOrigin.y - 30)
    self.addChild(pauseButton)
    self.addChild(playButton)
    playButton.isHidden = true
    
    let scorePosition = CGPoint(x: -cameraOrigin.x + 5, y: cameraOrigin.y - 15)
    scoreLabel.fontName = font
    scoreLabel.fontSize = fontSizeSmall
    scoreLabel.position = CGPoint(x: -cameraOrigin.x + 10, y: scorePosition.y)
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    scoreCountText.fontName = font
    scoreCountText.fontSize = fontSizeSmall
    scoreCountText.position = CGPoint(x: -cameraOrigin.x + 100, y: scorePosition.y)
    scoreCountText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    scoreCountText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    self.addChild(scoreLabel)
    self.addChild(scoreCountText)
    
    
    for index in 0 ..< 3 {
      let newHeartNode = SKSpriteNode(texture: textureAtlas.textureNamed("heart-full"))
      newHeartNode.size = CGSize (width: 40, height: 35)
      let xPos = -cameraOrigin.x + CGFloat(index * 50) + 30
      let yPos = cameraOrigin.y - 83
      newHeartNode.position = CGPoint(x: xPos, y: yPos)
      heartNodes.append(newHeartNode)
      self.addChild(newHeartNode)
    }
  }
  
  func setCoinCountDisplay(newCoinCount: Int) {
    let formatter = NumberFormatter()
    let number = NSNumber(value: newCoinCount)
    if let coinString = formatter.string(from: number) { coinCountText.text = coinString }
  }
  
  func setScoreDisplay(newScore: Int) {
    let formatter = NumberFormatter()
    let number = NSNumber(value: newScore)
    if let scoreString = formatter.string(from: number) { scoreCountText.text = scoreString }
  }
  
  func setHealthDisplay(newHealth: Int) {
    let fadeAction = SKAction.fadeAlpha(to: 0.2, duration: 0.3)
    
    for index in 0 ..< heartNodes.count {
      if index < newHealth {
        if dead { return }
        heartNodes[index].alpha = 1
      } else {
        heartNodes[index].run(fadeAction)
      }
    }
  }
}
