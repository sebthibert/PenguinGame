import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  let cam = SKCameraNode()
  let ground = Ground()
  let player = Player()
  let heartCrate = Crate()
  let hud = HUD()
  let encounterManager = EncounterManager()
  let particlePool = ParticlePool()
  var screenCenterY = CGFloat()
  let initialPlayerPosition = CGPoint(x: 150, y: 250)
  var nextEncounterSpawnPosition = CGFloat(150)
  var backgrounds: [Background] = []
  
  override func didMove(to view: SKView) {
    if !muted { self.run(SKAction.playSoundFileNamed("Sound/StartGame.aif", waitForCompletion: false)) }
    dead = false
    playerProgress = 0
    coinsCollected = 0
    self.anchorPoint = .zero
    self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
    self.camera = cam
    self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
    screenCenterY = self.size.height / 2
    self.physicsWorld.contactDelegate = self
    self.addChild(self.camera!)
    self.camera!.zPosition = 50
    ground.position = CGPoint(x: -self.size.width * 2, y: 30)
    ground.size = CGSize(width: self.size.width * 6, height: 0)
    ground.createChildren()
    self.addChild(ground)
    player.position = initialPlayerPosition
    self.addChild(player)
    encounterManager.addEncountersToScene(gameScene: self)
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
      
      if nodeTouched.name == "pauseGame" {
        if self.view?.isPaused == true { return }
        nodeTouched.isHidden = true
        hud.playButton.isHidden = false
        self.isPaused = true
      } else if nodeTouched.name == "playGame" {
        if self.view?.isPaused == true { return }
        nodeTouched.isHidden = true
        hud.pauseButton.isHidden = false
        self.isPaused = false
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
    self.camera!.position = CGPoint(x: player.position.x, y: player.position.y)
    playerProgress = player.position.x - initialPlayerPosition.x
    ground.checkForReposition(playerProgress: playerProgress)
    
    if player.position.x > nextEncounterSpawnPosition {
      encounterManager.placeNextEncounter(currentXPos: nextEncounterSpawnPosition)
      nextEncounterSpawnPosition += 1200
    }
    
    let random = Int(arc4random_uniform(10))
    
    if random == 1 {
      heartCrate.reset()
      heartCrate.position = CGPoint(x: nextEncounterSpawnPosition - 600, y: 270)
    }
    
    for background in self.backgrounds {
      background.updatePosition(playerProgress: playerProgress)
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    if self.view?.isPaused == true { return }
    hud.setScoreDisplay(newScore: Int(playerProgress/100))
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
      if let enemy = otherBody.node as? Bat {
        enemy.explode(gameScene: self)
      }
      if let enemy = otherBody.node as? Bee {
        enemy.explode(gameScene: self)
      }
      if let enemy = otherBody.node as? MadFly {
        enemy.explode(gameScene: self)
      }
    case PhysicsCategory.coin.rawValue:
      if let coin = otherBody.node as? Coin {
        coin.collect()
        coinsCollected += coin.value
        hud.setCoinCountDisplay(newCoinCount: coinsCollected)
      }
    case PhysicsCategory.powerup.rawValue:
      player.starPower()
      if let star = otherBody.node as? Star {
        star.explode(gameScene: self)
      }
    case PhysicsCategory.crate.rawValue:
      if let crate = otherBody.node as? Crate {
        crate.explode(gameScene: self)
      }
    default: break
    }
  }
  
  func gameOver() {
    self.view?.presentScene(EndScene(size: self.size), transition: .crossFade(withDuration: 0.6))
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
