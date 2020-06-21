//
//  GameScene.swift
//  StacksOnStacks
//
//  Created by Wesley Espinoza on 2/12/20.
//  Copyright © 2020 Erick Espinoza. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Player: UInt32 = 0b1
    static let Obstacle: UInt32 = 0b10
    static let Ground: UInt32 = 0b100
    static let PlayerBody: UInt32 = 0b1000
    static let Barrier: UInt32 = 0b10000
    static let Invisible: UInt32 = 0b100000
}

enum GameState: Equatable {
    case Paused
    case active
    case GameOver
    case Menu
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameState = GameState.Menu
    
    
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */
    let scrollSpeed: CGFloat = 200
    var scrollLayer: SKNode!
    var groundOffset: CGFloat = 2
    var player: Player!
    var obstacleSpawner: Obstacle!
    var playButton: ButtonNode!
    var frontBarrier: SKSpriteNode!
    
    
    
    
    override func sceneDidLoad() {
        player = self.childNode(withName: "player") as? Player
        player.setup()
        obstacleSpawner = self.childNode(withName: "obstacleSpawner") as? Obstacle
        playButton = self.childNode(withName: "playButton") as? ButtonNode
        frontBarrier = self.childNode(withName: "frontBarrier") as? SKSpriteNode
        frontBarrier.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frontBarrier.size.width, height: frontBarrier.size.height))
        frontBarrier.physicsBody?.isDynamic = true
        frontBarrier.physicsBody?.allowsRotation = false
        frontBarrier.physicsBody?.affectedByGravity = false
        frontBarrier.physicsBody?.categoryBitMask = PhysicsCategory.Barrier
        frontBarrier.physicsBody?.collisionBitMask = PhysicsCategory.None
        frontBarrier.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.PlayerBody | PhysicsCategory.Invisible
        
        scrollLayer = self.childNode(withName: "scrollLayer")
        
        playButton.selectedHandler = {
            self.gameState = .active
            self.playButton.isHidden = true
            let timer = Timer.scheduledTimer(timeInterval: self.fixedDelta, target: self, selector: #selector(self.startGenerator), userInfo: nil, repeats: true)
            
        }
        
        physicsWorld.contactDelegate = self
        
        
    }
    
    @objc func startGenerator(){
        self.obstacleSpawner.generate(scene: self.scene!)
        print("Timer Fires")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stack(scene: scene!)
    }
    
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        
        
    }
    
    
    
    
    func scrollWorld() {
        /* Scroll World */
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        /* Loop through scroll layer nodes */
        for ground in scrollLayer.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space */
            let groundPosition = scrollLayer.convert(ground.position, to: self)
            
            /* Check if ground sprite has left the scene */
            if groundPosition.x <= -ground.size.width / 2 {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPoint(x: (self.size.width / 2) + ground.size.width, y: groundPosition.y)
                
                /* Convert new node position back to scroll layer space */
                ground.position = self.convert(newPosition, to: scrollLayer)
                
            }
        }
    }
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == PhysicsCategory.Barrier {
            if bodyB.categoryBitMask == PhysicsCategory.Obstacle || bodyB.categoryBitMask == PhysicsCategory.PlayerBody || bodyB.categoryBitMask == PhysicsCategory.Invisible{
                bodyB.node?.removeFromParent()
            }
            
        }
        if bodyB.categoryBitMask == PhysicsCategory.Barrier {
            if bodyA.categoryBitMask == PhysicsCategory.Obstacle || bodyA.categoryBitMask == PhysicsCategory.PlayerBody || bodyA.categoryBitMask == PhysicsCategory.Invisible{
                bodyA.node?.removeFromParent()
            }
            
        }
        
    }
    
    
    func checkBody(){
        
        if player.bodyNodes.count >= 1 {
            
            for sprite in player.bodyNodes {
                if sprite.position.x < player.position.x - 5 {
                    player.bodyNodes = player.bodyNodes.filter {return $0 != sprite }
                    let rotate = SKAction.rotate(byAngle: 180, duration: 1.8)
                    let pushBack = SKAction.moveTo(x: sprite.position.x - 400, duration: 0.5)
                    let seq = SKAction.group([pushBack, rotate])
                    
                    sprite.run(SKAction.repeatForever(seq))
                    
                }
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        scrollWorld()
        if gameState == .active {
            checkBody()
        }
        
        
    }
}
