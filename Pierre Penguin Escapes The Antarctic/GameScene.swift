import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  let cam = SKCameraNode()
  let ground = Ground()
  let player = Player()
  let powerUpStar = Star()
  let heartCrate = Crate()
  let hud = HUD()
  let encounterManager = EncounterManager()
  let particlePool = ParticlePool()
  var screenCenterY = CGFloat()
  let initialPlayerPosition = CGPoint(x: 150, y: 250)
  var playerProgress = CGFloat()
  var nextEncounterSpawnPosition = CGFloat(150)
  var coinsCollected = 0
  var backgrounds: [Background] = []
  
  override func didMove(to view: SKView) {
    self.anchorPoint = .zero
    self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
    self.camera = cam
    self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
    screenCenterY = self.size.height / 2
    self.physicsWorld.contactDelegate = self
    self.addChild(self.camera!)
    self.camera!.zPosition = 50
    if !muted { self.run(SKAction.playSoundFileNamed("Sound/StartGame.aif", waitForCompletion: false)) }
    
    ground.position = CGPoint(x: -self.size.width * 2, y: 30)
    ground.size = CGSize(width: self.size.width * 6, height: 0)
    ground.createChildren()
    self.addChild(ground)
    
    player.position = initialPlayerPosition
    self.addChild(player)
    
    encounterManager.addEncountersToScene(gameScene: self)
  
    powerUpStar.position = CGPoint(x: -2000, y: -2000)
    self.addChild(powerUpStar)
  
    hud.createHudNodes(screenSize: self.size)
    self.camera!.addChild(hud)
    
    for _ in 0..<3 {
      backgrounds.append(Background())
    }

    backgrounds[0].spawn(parentNode: self, imageName: "background-front", zPosition: -5, movementMultiplier: 0.75)
    backgrounds[1].spawn(parentNode: self, imageName: "background-middle", zPosition: -10, movementMultiplier: 0.5)
    backgrounds[2].spawn(parentNode: self, imageName: "background-back", zPosition: -15, movementMultiplier: 0.2)
    
    if let dotEmitter = SKEmitterNode(fileNamed: "PierrePath") {
      player.zPosition = 10
      dotEmitter.particleZPosition = -1
      player.addChild(dotEmitter)
      dotEmitter.targetNode = self
    }
    
    particlePool.addEmittersToScene(scene: self)
    
    heartCrate.position = CGPoint(x: -2100, y: -2100)
    heartCrate.turnToHeartCrate()
    self.addChild(heartCrate)
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
    
    player.startFlapping()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    player.stopFlapping()
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    player.stopFlapping()
  }
  
  override func didSimulatePhysics() {
    var cameraYPos = screenCenterY
    cam.yScale = 1
    cam.xScale = 1
    
    if (player.position.y > screenCenterY) {
      cameraYPos = player.position.y
      let percentOfMaxHeight = (player.position.y - screenCenterY) / (player.maxHeight - screenCenterY)
      let newScale = 1 + percentOfMaxHeight
      cam.yScale = newScale
      cam.xScale = newScale
    }
    
    self.camera!.position = CGPoint(x: player.position.x, y: cameraYPos)
    playerProgress = player.position.x - initialPlayerPosition.x
    ground.checkForReposition(playerProgress: playerProgress)
    
    if player.position.x > nextEncounterSpawnPosition {
      encounterManager.placeNextEncounter(currentXPos: nextEncounterSpawnPosition)
      nextEncounterSpawnPosition += 1200
    }
    
    let starRoll = Int(arc4random_uniform(10))
    
    if starRoll == 0 {
      if abs(player.position.x - powerUpStar.position.x) > 1200 {
        let randomYPos = 50 + CGFloat(arc4random_uniform(400))
        powerUpStar.position = CGPoint(x: nextEncounterSpawnPosition, y: randomYPos)
        powerUpStar.physicsBody?.angularVelocity = 0
        powerUpStar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
      }
    }
    
    if starRoll == 1 {
      heartCrate.reset()
      heartCrate.position = CGPoint(x: nextEncounterSpawnPosition - 600, y: 270)
    }
    
    for background in self.backgrounds {
      background.updatePosition(playerProgress: playerProgress)
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    player.update()
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    let otherBody:SKPhysicsBody
    let penguinMask = PhysicsCategory.penguin.rawValue | PhysicsCategory.damagedPenguin.rawValue
    if (contact.bodyA.categoryBitMask & penguinMask) > 0 { otherBody = contact.bodyB }
    else { otherBody = contact.bodyA }
    
    switch otherBody.categoryBitMask {
    case PhysicsCategory.ground.rawValue:
      player.takeDamage()
      hud.setHealthDisplay(newHealth: player.health)
    case PhysicsCategory.enemy.rawValue:
      player.takeDamage()
      hud.setHealthDisplay(newHealth: player.health)
    case PhysicsCategory.coin.rawValue:
      if let coin = otherBody.node as? Coin {
        coin.collect()
        self.coinsCollected += coin.value
        hud.setCoinCountDisplay(newCoinCount: self.coinsCollected)
      }
    case PhysicsCategory.powerup.rawValue:
      player.starPower()
    case PhysicsCategory.crate.rawValue:
      if let crate = otherBody.node as? Crate {
        crate.explode(gameScene: self)
      }
    default: break
    }
  }
  
  func gameOver() {
    hud.showButtons()
  }
}

enum PhysicsCategory:UInt32 {
  case penguin = 1
  case damagedPenguin = 2
  case ground = 4
  case enemy = 8
  case coin = 16
  case powerup = 32
  case crate = 64
}
