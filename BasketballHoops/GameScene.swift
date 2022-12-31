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
    
    var yourScoreLabel : SKLabelNode?
    var numberScoreLabel : SKLabelNode?
    
    let mainMenuButton = SKSpriteNode(imageNamed: "mainMenuButton")
    
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
        
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        timerLabel = childNode(withName: "timerLabel") as? SKLabelNode
       
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
                scene?.isPaused = false
                yourScoreLabel?.removeFromParent()
                numberScoreLabel?.removeFromParent()
                initGame()
           }
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
                
        
        if contact.bodyA.categoryBitMask == hoopCategory {
            print("Point Shot A")
            score += 2
            scoreLabel?.text = "Score: \(score)"

        }
        if contact.bodyB.categoryBitMask == hoopCategory {
            print("Point Shot B")
            score += 2
            scoreLabel?.text = "Score: \(score)"

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
    }
    
    func gameOver() {
        //
            scene?.isPaused = true
            gameTimer?.invalidate()
            scoreLabel?.alpha = 0.5
            score = 0
            seconds = 60
            
            
            //            let controller = self.view?.window?.rootViewController as! GameViewController
            //            controller.showInterstitialAd()
            //
            
            yourScoreLabel = SKLabelNode()
            yourScoreLabel?.text = "Best Score"
            yourScoreLabel?.position = CGPoint(x: 0, y: 200)
            yourScoreLabel?.fontSize = 50
            yourScoreLabel?.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            yourScoreLabel?.zPosition = 30
            if yourScoreLabel != nil {
                addChild(yourScoreLabel!)
            }
            
            UserDefaults.standard.set(score, forKey: kScore)
            if score > UserDefaults.standard.integer(forKey: kBestScore) {
                UserDefaults.standard.set(score, forKey: kBestScore)
            }
            numberScoreLabel = SKLabelNode()
            numberScoreLabel?.text = "\(UserDefaults.standard.integer(forKey: kBestScore))"
            numberScoreLabel?.position = CGPoint(x: 0, y: 50)
            numberScoreLabel?.fontSize = 100
            numberScoreLabel?.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            numberScoreLabel?.zPosition = 30
            if numberScoreLabel != nil {
                addChild(numberScoreLabel!)
            }
            
            
            mainMenuButton.position = CGPoint(x: 0, y: -100)
            mainMenuButton.name = "mainMenu"
            mainMenuButton.zPosition = 30
            addChild(mainMenuButton)
            }
    
    func initGame() {
        if seconds >= 0 {
            gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.seconds -= 1
                self.timerLabel?.text = "Time: \(self.seconds)"
                print("\(self.seconds)")
                if self.seconds <= 0 {
                    self.gameOver()
                }
            }
        }
    }
}
