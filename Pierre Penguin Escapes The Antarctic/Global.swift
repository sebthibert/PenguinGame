import AVFoundation

public var muted: Bool = false
public var musicPlayer = AVAudioPlayer()
public var dead = false
public var playerProgress = CGFloat(0)
public var coinsCollected = 0
public var highScore = UserDefaults.standard.object(forKey: "HighScore") as! CGFloat
public var highCoinsCollected = UserDefaults.standard.object(forKey: "HighCoinsCollected") as! Int
public let fontSizeSmall: CGFloat = 25
public let fontSizeMedium: CGFloat = 40
public let fontSizeLarge: CGFloat = 60
public let font = "AvenirNext-HeavyItalic"

public func updateHighScores() {
  if playerProgress/100 > highScore {
    UserDefaults.standard.set(playerProgress/100, forKey:"HighScore")
    UserDefaults.standard.synchronize()
  }
  
  if coinsCollected > highCoinsCollected {
    UserDefaults.standard.set(coinsCollected, forKey:"HighCoinsCollected")
    UserDefaults.standard.synchronize()
  }
}
