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
    private var hoop : SKSpriteNode?
    private var startingPosition : SKSpriteNode?
    private var scoreLabel : SKLabelNode?
    private var timerLabel : SKLabelNode?
    
    private var scoreLabelNumber : SKLabelNode?
    private var bestScoreLabel : SKLabelNode?
    private var comboLabel : SKLabelNode?
    //private var comboValueLabel : SKLabelNode?
    private var menuOverlay : SKNode?
    
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
    var combo = 0
    var shotTaken = false
    var scoredThisShot = false
    var gameStarted = false
    
    var bestScore = 0
    let kScore = "Score"
    let kBestScore = "Best Score"
    
    var gameTimer : Timer?
    
    override func sceneDidLoad() {
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel?.text = "Score"
        scoreLabel?.position = CGPoint(x: -78, y: 420)
        scoreLabel?.fontSize = 30
        scoreLabel?.fontColor = #colorLiteral(red: 1, green: 0.5098039216, blue: 0, alpha: 1)
        scoreLabel?.zPosition = -1
        if scoreLabel != nil {
            addChild(scoreLabel!)
        }
        
        scoreLabelNumber = SKLabelNode(fontNamed: "Arial")
        scoreLabelNumber?.text = "0"
        scoreLabelNumber?.position = CGPoint(x: -78, y: 340)
        scoreLabelNumber?.fontSize = 50
        scoreLabelNumber?.fontColor = #colorLiteral(red: 1, green: 0.5098039216, blue: 0, alpha: 1)
        scoreLabelNumber?.zPosition = -1
        if scoreLabelNumber != nil {
            addChild(scoreLabelNumber!)
        }
        
        bestScoreLabel = SKLabelNode(fontNamed: "Arial")
        bestScoreLabel?.text = "Best Score"
        bestScoreLabel?.position = CGPoint(x: 88, y: 420)
        bestScoreLabel?.fontSize = 30
        bestScoreLabel?.fontColor = #colorLiteral(red: 1, green: 0.9882352941, blue: 0, alpha: 1)
        bestScoreLabel?.zPosition = -1
        if bestScoreLabel != nil {
            addChild(bestScoreLabel!)
        }
        
        numberBestScoreLabel = SKLabelNode(fontNamed: "Arial")
        numberBestScoreLabel?.text = "\(UserDefaults.standard.integer(forKey: kBestScore))"
        numberBestScoreLabel?.position = CGPoint(x: 83, y: 340)
        numberBestScoreLabel?.fontSize = 50
        numberBestScoreLabel?.fontColor = #colorLiteral(red: 1, green: 0.9882352941, blue: 0, alpha: 1)
        numberBestScoreLabel?.zPosition = -1
        if numberBestScoreLabel != nil {
            addChild(numberBestScoreLabel!)
        }

        comboLabel = SKLabelNode(fontNamed: "Arial")
        comboLabel?.text = "Combo x\(combo)"
        comboLabel?.position = CGPoint(x: 0, y: 205)
        comboLabel?.fontSize = 26
        comboLabel?.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        comboLabel?.zPosition = -1
        if comboLabel != nil {
            addChild(comboLabel!)
        }

        //comboValueLabel = SKLabelNode(fontNamed: "Arial")
        //comboValueLabel?.text = "x0"
        //comboValueLabel?.position = CGPoint(x: 50, y: 205)
        //comboValueLabel?.fontSize = 26
        //comboValueLabel?.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //comboValueLabel?.zPosition = -1
        //if comboValueLabel != nil {
          //  addChild(comboValueLabel!)
        //}
        
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
        
        showMainMenu()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchEnable && gameStarted {
            ball?.physicsBody?.applyForce(CGVector(dx: 0, dy: 50_000))
            touchEnable = false
            shotTaken = true
            scoredThisShot = false
        }
        
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)
        let theNodes = nodes(at: location)
                       
        for node in theNodes {
            if node.name == "startGameButton" {
                startGame()
            }

            if node.name == "mainMenu" {
                startGame()
           }
            
            if node.name == "resetButton" {
                node.removeFromParent()
                playAgainButton.removeFromParent()
                UserDefaults.standard.set(0, forKey: kBestScore)
                score = 0
                combo = 0
                scoreLabelNumber?.text = "\(score)"
                //comboValueLabel?.text = "x0"
                comboLabel?.text = "Combo x\(combo)"
                bestScore = 0
                numberBestScoreLabel?.text = "\(score)"
                UserDefaults.standard.set(0, forKey: kBestScore)
                showMainMenu()
           }
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
                
        if contact.bodyA.categoryBitMask == hoopCategory {
            registerScore()

        }
        if contact.bodyB.categoryBitMask == hoopCategory {
            registerScore()

        }
        
        if contact.bodyA.categoryBitMask == startingPositionCategory {
            resolveShotEnd()
            touchEnable = true
        }
        if contact.bodyB.categoryBitMask == startingPositionCategory {
            resolveShotEnd()
            touchEnable = true
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
    
    func gameOver() {
            gameTimer?.invalidate()
            gameStarted = false
            seconds = 60
            combo = 0
        
            ball?.position = CGPoint(x: 0, y: 110)
            touchEnable = false
            shotTaken = false
            scoredThisShot = false
            //comboValueLabel?.text = "x0"
            comboLabel?.text = "Combo x\(combo)"
            
            UserDefaults.standard.set(score, forKey: kScore)
            if score > UserDefaults.standard.integer(forKey: kBestScore) {
                UserDefaults.standard.set(score, forKey: kBestScore)
            }
            numberBestScoreLabel?.text = "\(UserDefaults.standard.integer(forKey: kBestScore))"

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
        gameTimer?.invalidate()
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

    func registerScore() {
        guard shotTaken, !scoredThisShot, gameStarted else { return }
        scoredThisShot = true
        score += 2
        combo += 1
        seconds += 5
        scoreLabelNumber?.text = "\(score)"
        //comboValueLabel?.text = "x\(combo)"
        comboLabel?.text = "Combo x\(combo)"
        timerLabel?.text = "Time Left: \(seconds)"
    }

    func resolveShotEnd() {
        guard shotTaken else { return }

        if !scoredThisShot {
            combo = 0
            //comboValueLabel?.text = "x0"
            comboLabel?.text = "Combo x\(combo)"
        }

        shotTaken = false
        scoredThisShot = false
    }

    func startGame() {
        menuOverlay?.removeFromParent()
        playAgainButton.removeFromParent()
        resetButton.removeFromParent()
        score = 0
        combo = 0
        seconds = 60
        shotTaken = false
        scoredThisShot = false
        gameStarted = true
        touchEnable = false
        scoreLabelNumber?.text = "0"
        //comboValueLabel?.text = "x0"
        comboLabel?.text = "Combo x\(combo)"
        timerLabel?.text = "Time Left: \(seconds)"
        ball?.position = CGPoint(x: 0, y: 110)
        initGame()
    }

    func showMainMenu() {
        gameTimer?.invalidate()
        gameStarted = false
        touchEnable = false
        shotTaken = false
        scoredThisShot = false
        seconds = 60
        timerLabel?.text = "Time Left: \(seconds)"
        ball?.position = CGPoint(x: 0, y: 110)

        menuOverlay?.removeFromParent()

        let overlay = SKNode()
        overlay.zPosition = 50

        let panel = SKShapeNode(rectOf: CGSize(width: 310, height: 330), cornerRadius: 32)
        panel.fillColor = UIColor(red: 0.07, green: 0.09, blue: 0.18, alpha: 0.88)
        panel.strokeColor = UIColor.orange
        panel.lineWidth = 4
        panel.position = CGPoint(x: 0, y: 0)
        overlay.addChild(panel)

        let title = SKLabelNode(fontNamed: "AvenirNext-Bold")
        title.text = "Basketball Hoops"
        title.fontSize = 32
        title.fontColor = .white
        title.position = CGPoint(x: 0, y: 96)
        title.zPosition = 51
        overlay.addChild(title)

        let subtitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        subtitle.text = "Arcade Challenge"
        subtitle.fontSize = 20
        subtitle.fontColor = UIColor.orange
        subtitle.position = CGPoint(x: 0, y: 58)
        subtitle.zPosition = 51
        overlay.addChild(subtitle)

        let info = SKLabelNode(fontNamed: "AvenirNext-Regular")
        info.text = "Score to build combo and earn +5s"
        info.fontSize = 18
        info.fontColor = .white
        info.position = CGPoint(x: 0, y: 8)
        info.zPosition = 51
        overlay.addChild(info)

        let best = SKLabelNode(fontNamed: "AvenirNext-Bold")
        best.text = "Best Score: \(UserDefaults.standard.integer(forKey: kBestScore))"
        best.fontSize = 20
        best.fontColor = .yellow
        best.position = CGPoint(x: 0, y: -34)
        best.zPosition = 51
        overlay.addChild(best)

        let button = SKShapeNode(rectOf: CGSize(width: 200, height: 64), cornerRadius: 22)
        button.name = "startGameButton"
        button.fillColor = UIColor.systemOrange
        button.strokeColor = .white
        button.lineWidth = 3
        button.position = CGPoint(x: 0, y: -110)
        button.zPosition = 51
        overlay.addChild(button)

        let buttonLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        buttonLabel.text = "Start Game"
        buttonLabel.name = "startGameButton"
        buttonLabel.fontSize = 24
        buttonLabel.fontColor = .white
        buttonLabel.verticalAlignmentMode = .center
        buttonLabel.position = CGPoint(x: 0, y: -110)
        buttonLabel.zPosition = 52
        overlay.addChild(buttonLabel)

        menuOverlay = overlay
        addChild(overlay)
    }
}
