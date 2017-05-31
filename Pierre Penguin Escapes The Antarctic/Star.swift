import SpriteKit

class Star: SKSpriteNode, GameSprite {
  var initialSize = CGSize(width: 40, height: 38)
  var textureAtlas = SKTextureAtlas(named: "Environment")
  var pulseAnimation = SKAction()
  var exploded = false
  
  init() {
    let starTexture = textureAtlas.textureNamed("star")
    super.init(texture: starTexture, color: .clear, size: initialSize)
    self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
    self.physicsBody?.affectedByGravity = false
    self.physicsBody?.categoryBitMask = PhysicsCategory.powerup.rawValue
  }
  
  func explode(gameScene: GameScene) {
    if exploded { return }
    exploded = true
    gameScene.particlePool.placeEmitter(node: self, emitterType: "enemy")
    self.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
    self.physicsBody?.categoryBitMask = 0
  }
  
  func reset() {
    self.alpha = 1
    self.physicsBody?.categoryBitMask = PhysicsCategory.powerup.rawValue
    exploded = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
