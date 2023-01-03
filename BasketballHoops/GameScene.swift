//
//  GameScene.swift
//  BasketballHoops
//
//  Created by Giorgio Giannotta on 09/12/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var ball : SKSpriteNode?
    private var button : SKSpriteNode?
    private var hoop : SKSpriteNode?
    private var startingPosition : SKSpriteNode?
    private var scoreLabel : SKLabelNode?
    private var timerLabel : SKLabelNode?
    
    private var scoreLabelNumber : SKLabelNode?
    private var bestScoreLabel : SKLabelNode?
    
    var yourScoreLabel : SKLabelNode?
    var numberBestScoreLabel : SKLabelNode?
    
    let playAgainButton = SKSpriteNode(imageNamed: "playAgainButton")
    
    let resetButton = SKSpriteNode(imageNamed: "resetButton")
    
    let ballCategory : UInt32 = 0x1 << 1
    let hoopCategory : UInt32 = 0x1 << 2
    let startingPositionCategory : UInt32 = 0x1 << 4
    
    var score = 0
    var touchEnable = false
    var seconds = 60
    
    var bestScore = 0
    let kScore = "Score"
    let kBestScore = "Best Score"
    
    var gameTimer : Timer?
    
    override func sceneDidLoad() {
        initGame()
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel?.text = "Score"
        scoreLabel?.position = CGPoint(x: -78, y: 420)
        scoreLabel?.fontSize = 30
        scoreLabel?.fontColor = #colorLiteral(red: 1, green: 0.2963023484, blue: 0, alpha: 1)
        scoreLabel?.zPosition = -1
        if scoreLabel != nil {
            addChild(scoreLabel!)
        }
        
        scoreLabelNumber = SKLabelNode(fontNamed: "Arial")
        scoreLabelNumber?.text = "0"
        scoreLabelNumber?.position = CGPoint(x: -78, y: 340)
        scoreLabelNumber?.fontSize = 50
        scoreLabelNumber?.fontColor = #colorLiteral(red: 1, green: 0.2963023484, blue: 0, alpha: 1)
        scoreLabelNumber?.zPosition = -1
        if scoreLabelNumber != nil {
            addChild(scoreLabelNumber!)
        }
        
        bestScoreLabel = SKLabelNode(fontNamed: "Arial")
        bestScoreLabel?.text = "Best Score"
        bestScoreLabel?.position = CGPoint(x: 88, y: 420)
        bestScoreLabel?.fontSize = 30
        bestScoreLabel?.fontColor = #colorLiteral(red: 0.4818688035, green: 1, blue: 0.2141556144, alpha: 1)
        bestScoreLabel?.zPosition = -1
        if bestScoreLabel != nil {
            addChild(bestScoreLabel!)
        }
        
        numberBestScoreLabel = SKLabelNode(fontNamed: "Arial")
        numberBestScoreLabel?.text = "\(UserDefaults.standard.integer(forKey: kBestScore))"
        numberBestScoreLabel?.position = CGPoint(x: 83, y: 340)
        numberBestScoreLabel?.fontSize = 50
        numberBestScoreLabel?.fontColor = #colorLiteral(red: 0.4818688035, green: 1, blue: 0.2141556144, alpha: 1)
        numberBestScoreLabel?.zPosition = -1
        if numberBestScoreLabel != nil {
            addChild(numberBestScoreLabel!)
        }
        
        timerLabel = SKLabelNode(fontNamed: "Arial")
        timerLabel?.position = CGPoint(x: 0, y: 480)
        timerLabel?.text = "Time Left: \(seconds)"
        timerLabel?.fontSize = 50
        timerLabel?.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        timerLabel?.zPosition = -1
        if timerLabel != nil {
            addChild(timerLabel!)
        }
        
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        ball = childNode(withName: "ball") as? SKSpriteNode
        ball?.physicsBody?.categoryBitMask = ballCategory
        ball?.physicsBody?.contactTestBitMask = hoopCategory
        
        hoop = childNode(withName: "hoopInside") as? SKSpriteNode
        hoop?.physicsBody?.categoryBitMask = hoopCategory
        hoop?.physicsBody?.contactTestBitMask = ballCategory
        
        startingPosition = childNode(withName: "startingPosition") as? SKSpriteNode
        startingPosition?.physicsBody?.categoryBitMask = startingPositionCategory
        startingPosition?.physicsBody?.contactTestBitMask = ballCategory
        
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchEnable {
            ball?.physicsBody?.applyForce(CGVector(dx: 0, dy: 50_000))
            touchEnable = false
        }
        
        let touch: UITouch = touches.first! as UITouch
                let location: CGPoint = touch.location(in: self)
                
                 let theNodes = nodes(at: location)
                       
        for node in theNodes {
            if node.name == "mainMenu" {
                node.removeFromParent()
                resetButton.removeFromParent()
                scene?.isPaused = false
                initGame()
           }
            
            if node.name == "resetButton" {
                node.removeFromParent()
                playAgainButton.removeFromParent()
                UserDefaults.standard.set(0, forKey: kBestScore)
                scene?.isPaused = false
                initGame()
           }
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
                
        
        if contact.bodyA.categoryBitMask == hoopCategory {
            print("Point Shot A")
            score += 2
            scoreLabelNumber?.text = "\(score)"

        }
        if contact.bodyB.categoryBitMask == hoopCategory {
            print("Point Shot B")
            score += 2
            scoreLabelNumber?.text = "\(score)"

        }
        
        if contact.bodyA.categoryBitMask == startingPositionCategory {
            print("Re-enable touch A")
            touchEnable = true
        }
        if contact.bodyB.categoryBitMask == startingPositionCategory {
            print("Re-enable touch B")
            touchEnable = true
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
//        numberBestScoreLabel = SKLabelNode(fontNamed: "Arial")
//        numberBestScoreLabel?.text = "\(UserDefaults.standard.integer(forKey: kBestScore))"
//        numberBestScoreLabel?.position = CGPoint(x: 88, y: 340)
//        numberBestScoreLabel?.fontSize = 50
//        numberBestScoreLabel?.fontColor = #colorLiteral(red: 0.4818688035, green: 1, blue: 0.2141556144, alpha: 1)
//        numberBestScoreLabel?.zPosition = -1
//        if numberBestScoreLabel != nil {
//            addChild(numberBestScoreLabel!)
//        }
    }
    
    func gameOver() {
            scene?.isPaused = true
            gameTimer?.invalidate()
            seconds = 60
            
            UserDefaults.standard.set(score, forKey: kScore)
            if score > UserDefaults.standard.integer(forKey: kBestScore) {
                UserDefaults.standard.set(score, forKey: kBestScore)
            }
            numberBestScoreLabel?.text = "\(UserDefaults.standard.integer(forKey: kBestScore))"

            score = 0
        
            playAgainButton.position = CGPoint(x: 0, y: -100)
            playAgainButton.name = "mainMenu"
            playAgainButton.zPosition = 30
            addChild(playAgainButton)
        
            resetButton.position = CGPoint(x: 0, y: -180)
            resetButton.name = "resetButton"
            resetButton.zPosition = 30
            addChild(resetButton)
            }
    
    func initGame() {
        if seconds >= 0 {
            gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.seconds -= 1
                self.timerLabel?.text = "Time Left: \(self.seconds)"
                print("\(self.seconds)")
                if self.seconds <= 0 {
                    self.gameOver()
                }
            }
        }
    }
}
