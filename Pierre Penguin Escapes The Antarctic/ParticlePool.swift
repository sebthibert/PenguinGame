import SpriteKit

class ParticlePool {
  var cratePool:[SKEmitterNode] = []
  var heartPool:[SKEmitterNode] = []
  var crateIndex = 0
  var heartIndex = 0
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
  }
  
  func addEmittersToScene(scene: GameScene) {
    self.gameScene = scene
    
    for i in 0..<cratePool.count {
      self.gameScene.addChild(cratePool[i])
    }
    
    for i in 0..<heartPool.count {
      self.gameScene.addChild(heartPool[i])
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
