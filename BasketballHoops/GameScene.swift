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
    
    let ballCategory : UInt32 = 0x1 << 1
    let hoopCategory : UInt32 = 0x1 << 2
    let startingPositionCategory : UInt32 = 0x1 << 4
    
    var score = 0
    var touchEnable = true
    var seconds = 60
    
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
        
        if seconds >= 0{
            var timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.seconds -= 1
                print("\(self.seconds)")
                if self.seconds <= 0 {
                    self.score = 0
                    timer.invalidate()
                }
            }
        }
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchEnable {
            ball?.physicsBody?.applyForce(CGVector(dx: 0, dy: 50_000))
            touchEnable = false
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
}
