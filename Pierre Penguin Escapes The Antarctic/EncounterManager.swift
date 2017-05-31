import SpriteKit

class EncounterManager {
  let encounterNames:[String] = ["EncounterA", "EncounterB", "EncounterC"]
  var encounters:[SKNode] = []
  var currentEncounterIndex: Int?
  var previousEncounterIndex: Int?
  
  init() {
    for encounterFileName in encounterNames {
      let encounterNode = SKNode()
      if let encounterScene = SKScene(fileNamed: encounterFileName) {
        for child in encounterScene.children {
          let copyOfNode = type(of: child).init()
          copyOfNode.position = child.position
          copyOfNode.name = child.name
          encounterNode.addChild(copyOfNode)
        }
      }
      
      encounters.append(encounterNode)
      saveSpritePositions(node: encounterNode)
      encounterNode.enumerateChildNodes(withName: "gold") { (node: SKNode, stop: UnsafeMutablePointer) in (node as? Coin)?.turnToGold() }
    }
  }
  
  func addEncountersToScene(gameScene:SKNode) {
    var encounterPosY = 1000
    for encounterNode in encounters {
      encounterNode.position = CGPoint(x: -2000, y: encounterPosY)
      gameScene.addChild(encounterNode)
      encounterPosY *= 2
    }
  }
  
  func saveSpritePositions(node: SKNode) {
    for sprite in node.children {
      if let spriteNode = sprite as? SKSpriteNode {
        let initialPositionValue = NSValue.init(cgPoint: sprite.position)
        spriteNode.userData = ["initialPosition": initialPositionValue]
        saveSpritePositions(node: spriteNode)
      }
    }
  }
  
  func resetSpritePositions(node: SKNode) {
    for sprite in node.children {
      if let spriteNode = sprite as? SKSpriteNode {
        spriteNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        spriteNode.physicsBody?.angularVelocity = 0
        spriteNode.zRotation = 0
        
        if let batTest = spriteNode as? Bat {
          batTest.reset()
        }
        
        if let beeTest = spriteNode as? Bee {
          beeTest.reset()
        }
        
        if let madFlyTest = spriteNode as? MadFly {
          madFlyTest.reset()
        }
        
        
        if let crateTest = spriteNode as? Crate {
          crateTest.reset()
        }
        
        if let initialPositionVal = spriteNode.userData?.value(forKey: "initialPosition") as? NSValue {
          spriteNode.position = initialPositionVal.cgPointValue
        }
        
        resetSpritePositions(node: spriteNode)
      }
    }
  }
  
  func placeNextEncounter(currentXPos: CGFloat) {
    let encounterCount = UInt32(encounters.count)
    if encounterCount < 3 { return }
    var nextEncounterIndex: Int?
    var trulyNew: Bool?
    
    while trulyNew == false || trulyNew == nil {
      nextEncounterIndex = Int(arc4random_uniform(encounterCount))
      trulyNew = true

      if let currentIndex = currentEncounterIndex {
        if (nextEncounterIndex == currentIndex) { trulyNew = false }
      }
      
      if let previousIndex = previousEncounterIndex {
        if (nextEncounterIndex == previousIndex) { trulyNew = false }
      }
    }
    
    previousEncounterIndex = currentEncounterIndex
    currentEncounterIndex = nextEncounterIndex
    
    let encounter = encounters[currentEncounterIndex!]
    encounter.position = CGPoint(x: currentXPos + 1000, y: 300)
    resetSpritePositions(node: encounter)
  }
}
