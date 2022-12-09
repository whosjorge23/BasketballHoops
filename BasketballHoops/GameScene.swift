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
    private var scoreLabel : SKLabelNode?
    
    let ballCategory : UInt32 = 0x1 << 1
    let hoopCategory : UInt32 = 0x1 << 2
    
    var score = 0
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        ball = childNode(withName: "ball") as? SKSpriteNode
        ball?.physicsBody?.categoryBitMask = ballCategory
        ball?.physicsBody?.contactTestBitMask = hoopCategory
        
        hoop = childNode(withName: "hoopInside") as? SKSpriteNode
        hoop?.physicsBody?.categoryBitMask = hoopCategory
        hoop?.physicsBody?.contactTestBitMask = ballCategory
        
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ball?.physicsBody?.applyForce(CGVector(dx: 0, dy: 50_000))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        score += 2
        scoreLabel?.text = "Score: \(score)"
        
        if contact.bodyA.categoryBitMask == ballCategory {
            print("touch A")
        }
        if contact.bodyB.categoryBitMask == ballCategory {
            print("touch B")
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
