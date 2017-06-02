import SpriteKit

class Crate: SKSpriteNode, GameSprite {
  var initialSize = CGSize(width: 40, height: 40)
  var textureAtlas = SKTextureAtlas(named: "Environment")
  var givesHeart = false
  var exploded = false
  
  init() {
    super.init(texture: nil, color: UIColor.clear, size: initialSize)
    self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
    self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue | PhysicsCategory.crate.rawValue
    self.physicsBody?.categoryBitMask = PhysicsCategory.crate.rawValue
    self.texture = textureAtlas.textureNamed("crate")
  }
  
  func turnToHeartCrate() {
    self.physicsBody?.affectedByGravity = false
    self.texture = textureAtlas.textureNamed("crate-power-up")
    givesHeart = true
  }
  
  func explode(gameScene: GameScene) {
    if exploded { return }
    exploded = true
    gameScene.particlePool.placeEmitter(node: self, emitterType: "crate")
    self.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
    
    if (givesHeart) {
      let newHealth = gameScene.player.health + 1
      let maxHealth = gameScene.player.maxHealth
      gameScene.player.health = newHealth > maxHealth ? maxHealth : newHealth
      gameScene.hud.setHealthDisplay(newHealth: gameScene.player.health)
      gameScene.particlePool.placeEmitter(node: self, emitterType: "heart")
    } else {
      coinsCollected += 1
      gameScene.hud.setCoinCountDisplay(newCoinCount: coinsCollected)
    }

    self.physicsBody?.categoryBitMask = 0
  }
  
  func reset() {
    self.alpha = 1
    self.physicsBody?.categoryBitMask = PhysicsCategory.crate.rawValue
    exploded = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
