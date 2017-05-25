import SpriteKit

class GameScene: SKScene {
  let cam = SKCameraNode()
  let ground = Ground()
  let player = Player()
  var screenCenterY = CGFloat()
  let initialPlayerPosition = CGPoint(x: 150, y: 250)
  var playerProgress = CGFloat()
  let encounterManager = EncounterManager()
  var nextEncounterSpawnPosition = CGFloat(150)
  
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
  }
  
  override func update(_ currentTime: TimeInterval) {
    player.update()
  }
}
