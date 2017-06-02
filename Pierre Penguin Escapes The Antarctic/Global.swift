import AVFoundation

public var muted: Bool = false
public var musicPlayer = AVAudioPlayer()
public var dead = false
public var playerProgress = CGFloat(0)
public var coinsCollected = 0
public var highScore = UserDefaults.standard.object(forKey: "HighScore") as? CGFloat ?? 0
public var highCoinsCollected = UserDefaults.standard.object(forKey: "HighCoinsCollected") as? Int ?? 0
public let fontSizeSmall: CGFloat = 25
public let fontSizeMedium: CGFloat = 40
public let fontSizeLarge: CGFloat = 60
public let font = "AvenirNext-HeavyItalic"
