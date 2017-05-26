import SpriteKit

class MadFly: SKSpriteNode, GameSprite {
  var initialSize = CGSize(width: 61, height: 29)
  var textureAtlas = SKTextureAtlas(named:"Enemies")
  var flyAnimation = SKAction()
  
  init() {
    super.init(texture: nil, color: .clear, size: initialSize)
    createAnimations()
    self.run(flyAnimation)
    self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
    self.physicsBody?.affectedByGravity = false
    self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
    self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
  }
  
  func createAnimations() {
    let flyFrames:[SKTexture] = [textureAtlas.textureNamed("madfly"), textureAtlas.textureNamed("madfly-fly")]
    let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.12)
    flyAnimation = SKAction.repeatForever(flyAction)
  }
  
  func onTap() {}
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
