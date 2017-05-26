import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  let cam = SKCameraNode()
  let ground = Ground()
  let player = Player()
  var screenCenterY = CGFloat()
  let initialPlayerPosition = CGPoint(x: 150, y: 250)
  var playerProgress = CGFloat()
  let encounterManager = EncounterManager()
  var nextEncounterSpawnPosition = CGFloat(150)
  let powerUpStar = Star()
  var coinsCollected = 0
  let hud = HUD()
  var backgrounds:[Background] = []
  
  override func didMove(to view: SKView) {
    self.anchorPoint = .zero
    self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue:
      0.95, alpha: 1.0)
    
    // Assign the camera to the scene
    self.camera = cam
    
    // Add the ground to the scene:
    ground.position = CGPoint(x: -self.size.width * 2, y: 30)
    ground.size = CGSize(width: self.size.width * 6, height: 0)
    ground.createChildren()
    self.addChild(ground)
    
    // Add the player to the scene:
    player.position = initialPlayerPosition
    self.addChild(player)
    
    // Set gravity
    self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
    
    // Store the vertical center of the screen:
    screenCenterY = self.size.height / 2
    
    encounterManager.addEncountersToScene(gameScene: self)
    
    // Place the star out of the way for now:
    self.addChild(powerUpStar)
    powerUpStar.position = CGPoint(x: -2000, y: -2000)
    self.physicsWorld.contactDelegate = self
    
    // Add the camera itself to the scene's node tree:
    self.addChild(self.camera!)
    // Position the camera node above the game elements:
    self.camera!.zPosition = 50
    // Create the HUD's child nodes:
    hud.createHudNodes(screenSize: self.size)
    // Add the HUD to the camera's node tree:
    self.camera!.addChild(hud)
    
    // Instantiate three Backgrounds to the backgrounds array:
    for _ in 0..<3 {
      backgrounds.append(Background())
    }
    // Spawn the new backgrounds:
    backgrounds[0].spawn(parentNode: self,
                         imageName: "background-front", zPosition: -5,
                         movementMultiplier: 0.75)
    backgrounds[1].spawn(parentNode: self,
                         imageName: "background-middle", zPosition: -10,
                         movementMultiplier: 0.5)
    backgrounds[2].spawn(parentNode: self,
                         imageName: "background-back", zPosition: -15,
                         movementMultiplier: 0.2)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>,
                             with event: UIEvent?) {
    for touch in (touches) {
      // Find the location of the touch:
      let location = touch.location(in: self)
      // Locate the node at this location:
      let nodeTouched = atPoint(location)
      // Attempt to downcast the node to the GameSprite protocol
      if let gameSprite = nodeTouched as? GameSprite {
        // If this node adheres to GameSprite, call onTap:
        gameSprite.onTap()
      }
    }
    
    player.startFlapping()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>,
                             with event: UIEvent?) {
    player.stopFlapping()
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>,
                                 with event: UIEvent?) {
    player.stopFlapping()
  }
  
  override func didSimulatePhysics() {
    // Keep the camera locked at mid screen by default:
    var cameraYPos = screenCenterY
    cam.yScale = 1
    cam.xScale = 1
    
    // Follow the player up if higher than half the screen:
    if (player.position.y > screenCenterY) {
      cameraYPos = player.position.y
      // Scale out the camera as they go higher:
      let percentOfMaxHeight = (player.position.y -
        screenCenterY) / (player.maxHeight -
          screenCenterY)
      let newScale = 1 + percentOfMaxHeight
      cam.yScale = newScale
      cam.xScale = newScale
    }
    
    // Move the camera for our adjustment:
    self.camera!.position = CGPoint(x: player.position.x,
                                    y: cameraYPos)
    
    // Keep track of how far the player has flown
    playerProgress = player.position.x -
      initialPlayerPosition.x
    
    // Check to see if the ground should jump forward:
    ground.checkForReposition(playerProgress: playerProgress)
    
    // Check to see if we should set a new encounter:
    if player.position.x > nextEncounterSpawnPosition {
      encounterManager.placeNextEncounter(
        currentXPos: nextEncounterSpawnPosition)
      nextEncounterSpawnPosition += 1200
    }
    
    // Each encounter has a 10% chance to spawn a star:
    let starRoll = Int(arc4random_uniform(10))
    if starRoll == 0 {
      // Only move the star if it is off the screen.
      if abs(player.position.x - powerUpStar.position.x)
        > 1200 {
        // Y Position 50-450:
        let randomYPos = 50 +
          CGFloat(arc4random_uniform(400))
        powerUpStar.position = CGPoint(x:
          nextEncounterSpawnPosition, y: randomYPos)
        // Remove any previous velocity and spin:
        powerUpStar.physicsBody?.angularVelocity = 0
        powerUpStar.physicsBody?.velocity =
          CGVector(dx: 0, dy: 0)
      }
    }
    
    // Position the backgrounds:
    for background in self.backgrounds {
      background.updatePosition(playerProgress:
        playerProgress)
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    player.update()
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    // Each contact has two bodies,
    // We do not know which is which.
    // We will find the penguin body first, then use
    // the other body to determine the type of contact.
    let otherBody:SKPhysicsBody
    // Combine the two penguin physics categories into one
    // bitmask using the bitwise OR operator |
    let penguinMask = PhysicsCategory.penguin.rawValue |
      PhysicsCategory.damagedPenguin.rawValue
    // Use the bitwise AND operator & to find the penguin.
    // This returns a positive number if body A's category
    // is the same as either the penguin or damagedPenguin:
    if (contact.bodyA.categoryBitMask & penguinMask) > 0 {
      // bodyA is the penguin, we will test bodyB's type:
      otherBody = contact.bodyB
    }
    else {
      // bodyB is the penguin, we will test bodyA's type:
      otherBody = contact.bodyA
    }
    // Find the type of contact:
    switch otherBody.categoryBitMask {
    case PhysicsCategory.ground.rawValue:
      player.takeDamage()
      hud.setHealthDisplay(newHealth: player.health)
    case PhysicsCategory.enemy.rawValue:
      player.takeDamage()
      hud.setHealthDisplay(newHealth: player.health)
    case PhysicsCategory.coin.rawValue:
      // Try to cast the otherBody's node as a Coin:
      if let coin = otherBody.node as? Coin {
        // Invoke the collect animation:
        coin.collect()
        // Add the value of the coin to our counter:
        self.coinsCollected += coin.value
        hud.setCoinCountDisplay(newCoinCount: self.coinsCollected)
      }
    case PhysicsCategory.powerup.rawValue:
      player.starPower()
    default:
      print("Contact with no game logic")
    }
  }
}

enum PhysicsCategory:UInt32 {
  case penguin = 1
  case damagedPenguin = 2
  case ground = 4
  case enemy = 8
  case coin = 16
  case powerup = 32
}
