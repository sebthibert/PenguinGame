import SpriteKit

class Player: SKSpriteNode, GameSprite {
  var initialSize = CGSize(width: 64, height: 64)
  var textureAtlas = SKTextureAtlas(named:"Pierre")
  var flyAnimation = SKAction()
  var soarAnimation = SKAction()
  var damageAnimation = SKAction()
  var dieAnimation = SKAction()
  var flapping = false
  let maxFlappingForce = CGFloat(57000)
  let maxHeight = CGFloat(350)
  var health = 3
  let maxHealth = 3
  var invulnerable = false
  var damaged = false
  var forwardVelocity = CGFloat(200)
  let powerupSound = SKAction.playSoundFileNamed("Sound/Powerup.aif", waitForCompletion: false)
  let hurtSound = SKAction.playSoundFileNamed("Sound/Hurt.aif", waitForCompletion: false)
  
  init() {
    super.init(texture: nil, color: .clear, size: initialSize)
    createAnimations()
    self.run(soarAnimation, withKey: "soarAnimation")
    let bodyTexture = textureAtlas.textureNamed("pierre-flying-3")
    self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: self.size)
    self.physicsBody?.linearDamping = 0.9
    self.physicsBody?.mass = 30
    self.physicsBody?.allowsRotation = false
    self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
    self.physicsBody?.contactTestBitMask =
      PhysicsCategory.enemy.rawValue |
      PhysicsCategory.ground.rawValue |
      PhysicsCategory.powerup.rawValue |
      PhysicsCategory.coin.rawValue |
      PhysicsCategory.crate.rawValue
    self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
    self.physicsBody?.affectedByGravity = false
    self.physicsBody?.velocity.dy = 80
    
    let startGravitySequence = SKAction.sequence([
      SKAction.wait(forDuration: 0.6),
      SKAction.run {
        self.physicsBody?.affectedByGravity = true
      }])
    
    self.run(startGravitySequence)
  }
  
  func createAnimations() {
    let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
    rotateUpAction.timingMode = .easeOut
    let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.8)
    rotateDownAction.timingMode = .easeIn
    
    let flyFrames:[SKTexture] = [
      textureAtlas.textureNamed("pierre-flying-1"),
      textureAtlas.textureNamed("pierre-flying-2"),
      textureAtlas.textureNamed("pierre-flying-3"),
      textureAtlas.textureNamed("pierre-flying-4"),
      textureAtlas.textureNamed("pierre-flying-3"),
      textureAtlas.textureNamed("pierre-flying-2")
    ]
    
    let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.03)
    flyAnimation = SKAction.group([SKAction.repeatForever(flyAction), rotateUpAction ])
    
    let soarFrames:[SKTexture] = [textureAtlas.textureNamed("pierre-flying-1")]
    let soarAction = SKAction.animate(with: soarFrames, timePerFrame: 1)
    soarAnimation = SKAction.group([SKAction.repeatForever(soarAction), rotateDownAction])
    
    let damageStart = SKAction.run {
      self.physicsBody?.categoryBitMask = PhysicsCategory.damagedPenguin.rawValue
    }
    
    let slowFade = SKAction.sequence([
      SKAction.fadeAlpha(to: 0.3, duration: 0.30),
      SKAction.fadeAlpha(to: 0.7, duration: 0.30)
      ])
    
    let fastFade = SKAction.sequence([
      SKAction.fadeAlpha(to: 0.3, duration: 0.15),
      SKAction.fadeAlpha(to: 0.7, duration: 0.15)
      ])
    
    let fadeOutAndIn = SKAction.sequence([
      SKAction.repeat(slowFade, count: 2),
      SKAction.repeat(fastFade, count: 5),
      SKAction.fadeAlpha(to: 1, duration: 0.15)
      ])

    let damageEnd = SKAction.run {
      self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
      self.damaged = false
    }
    
    self.damageAnimation = SKAction.sequence([damageStart, fadeOutAndIn, damageEnd])
    
    let startDie = SKAction.run {
      self.texture = self.textureAtlas.textureNamed("pierre-dead")
    }
    
    let openMenuAnimation = SKAction.run {
      if let gameScene = self.parent as? GameScene {
        gameScene.gameOver()
      }
    }
    
    self.dieAnimation = SKAction.sequence([
      startDie,
      SKAction.rotate(toAngle: -1, duration: 1),
      SKAction.wait(forDuration: 1),
      openMenuAnimation
      ]) 
  }
  
  func update() {
    if self.flapping {
      var forceToApply = maxFlappingForce
      
      if position.y > 600 {
        let percentageOfMaxHeight = position.y / maxHeight
        let flappingForceSubtraction = percentageOfMaxHeight * maxFlappingForce
        forceToApply -= flappingForceSubtraction
      }

      self.physicsBody?.applyForce(CGVector(dx: 0, dy: forceToApply))
    }
    
    if self.physicsBody!.velocity.dy > 300 {
      self.physicsBody!.velocity.dy = 300
    }
    
    self.forwardVelocity = self.forwardVelocity * 1.0001
    self.physicsBody?.velocity.dx = self.forwardVelocity
  }
  
  func startFlapping() {
    if self.health <= 0 { return }
    self.removeAction(forKey: "soarAnimation")
    self.run(flyAnimation, withKey: "flapAnimation")
    self.flapping = true
  }
  
  func stopFlapping() {
    if self.health <= 0 { return }
    self.removeAction(forKey: "flapAnimation")
    self.run(soarAnimation, withKey: "soarAnimation")
    self.flapping = false
  }
  
  func takeDamage() {
    if self.invulnerable || self.damaged { return }
    self.damaged = true

    self.health -= 1
    if self.health == 0 {
      die()
    } else {
      self.run(self.damageAnimation, withKey: "damageAnimation")
    }

    if !muted { self.run(hurtSound) }
  }
  
  func die() {
    dead = true
    self.alpha = 1
    self.removeAllActions()
    self.run(self.dieAnimation)
    self.flapping = false
    self.forwardVelocity = 0
    
    if playerProgress / 100 > highScore {
      UserDefaults.standard.set(playerProgress / 100, forKey:"HighScore")
      UserDefaults.standard.synchronize()
    }
    
    if coinsCollected > highCoinsCollected {
      UserDefaults.standard.set(coinsCollected, forKey:"HighCoinsCollected")
      UserDefaults.standard.synchronize()
    }
  }
  
  func starPower() {
    if dead { return }
    self.alpha = 1
    self.removeAction(forKey: "starPower")
    self.removeAction(forKey: "damageAnimation")
    self.forwardVelocity = forwardVelocity * 1.5
    self.invulnerable = true
    
    let starSequence = SKAction.sequence([
      SKAction.scale(to: 1.5, duration: 0.3),
      SKAction.wait(forDuration: 3),
      damageAnimation,
      SKAction.scale(to: 1, duration: 1),
      
      SKAction.run {
        self.forwardVelocity = self.forwardVelocity / 1.5
        self.invulnerable = false
      }
      ])
    
    self.run(starSequence, withKey: "starPower")
    
    if !muted { self.run(powerupSound) }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
