import SpriteKit

class ParticlePool {
  var cratePool: [SKEmitterNode] = []
  var heartPool: [SKEmitterNode] = []
  var enemyPool: [SKEmitterNode] = []
  var crateIndex = 0
  var heartIndex = 0
  var enemyIndex = 0
  var gameScene = SKScene()
  
  init() {
    for i in 1...5 {
      let crate = SKEmitterNode(fileNamed: "CrateExplosion")!
      crate.position = CGPoint(x: -2000, y: -2000)
      crate.zPosition = CGFloat(45 - i)
      crate.name = "crate" + String(i)
      cratePool.append(crate)
    }

    for i in 1...1 {
      let heart = SKEmitterNode(fileNamed: "HeartExplosion")!
      heart.position = CGPoint(x: -2000, y: -2000)
      heart.zPosition = CGFloat(45 - i)
      heart.name = "heart" + String(i)
      heartPool.append(heart)
    }
    
    for i in 1...5 {
      let enemy = SKEmitterNode(fileNamed: "EnemyCollision")!
      enemy.position = CGPoint(x: -2000, y: -2000)
      enemy.zPosition = CGFloat(45 - i)
      enemy.name = "enemy" + String(i)
      enemyPool.append(enemy)
    }
  }
  
  func addEmittersToScene(scene: GameScene) {
    self.gameScene = scene
    
    for i in 0..<cratePool.count {
      self.gameScene.addChild(cratePool[i])
    }
    
    for i in 0..<heartPool.count {
      self.gameScene.addChild(heartPool[i])
    }
    
    for i in 0..<enemyPool.count {
      self.gameScene.addChild(enemyPool[i])
    }
  }
  
  func placeEmitter(node:SKNode, emitterType:String)
  {
    var emitter:SKEmitterNode
    switch emitterType {
    case "crate":
      emitter = cratePool[crateIndex]
      crateIndex += 1
      if crateIndex >= cratePool.count {
        crateIndex = 0
      }
    case "heart":
      emitter = heartPool[heartIndex]
      heartIndex += 1
      if heartIndex >= heartPool.count {
        heartIndex = 0
      }
    case "enemy":
      emitter = enemyPool[enemyIndex]
      enemyIndex += 1
      if enemyIndex >= enemyPool.count {
        enemyIndex = 0
      }
    default:
      return
    }
    
    var absolutePosition = node.position
    if node.parent != gameScene {
      absolutePosition = gameScene.convert(node.position, from:
          node.parent!)
    }
    
    emitter.position = absolutePosition
    emitter.resetSimulation()
  }
}
