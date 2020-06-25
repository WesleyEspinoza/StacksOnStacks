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
    case Active
    case Menu
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameState: GameState = .Menu {
        didSet{
            switch gameState {
            case .Active:
                for node in player.bodyNodes {
                    node.removeFromParent()
                }
                player.removeAllActions()
                self.player.position.x = self.player.initialPos.x
                self.player.zRotation = 0
                self.playButton.isHidden = true
                self.obstacleTimer = Timer.scheduledTimer(timeInterval: self.fixedDelta, target: self, selector: #selector(self.startGenerator), userInfo: nil, repeats: true)
            case .Menu:
                self.playButton.isHidden = false
                self.obstacleTimer.invalidate()
                for node in self.children {
                    if node.physicsBody?.categoryBitMask == PhysicsCategory.Obstacle {
                        node.removeFromParent()
                    }
                }
            }
        }
    }
    
    
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */
    let scrollSpeed: CGFloat = 200
    var scrollLayer: SKNode!
    var groundOffset: CGFloat = 2
    var player: Player!
    var obstacleSpawner: Obstacle!
    var playButton: ButtonNode!
    var frontBarrier: SKSpriteNode!
    var obstacleTimer: Timer!
    
    
    
    
    override func sceneDidLoad() {
        player = self.childNode(withName: "player") as? Player
        player.setup()
        obstacleSpawner = self.childNode(withName: "obstacleSpawner") as? Obstacle
        if let playButton = self.childNode(withName: "playButton") as? ButtonNode {
            self.playButton = playButton
        } else {
            print("not ")
        }
        frontBarrier = self.childNode(withName: "frontBarrier") as? SKSpriteNode

        frontBarrier.physicsBody?.categoryBitMask = PhysicsCategory.Barrier
        frontBarrier.physicsBody?.collisionBitMask = PhysicsCategory.None
        frontBarrier.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle
        
        scrollLayer = self.childNode(withName: "scrollLayer")
        
        playButton.selectedHandler = {
            self.gameState = .Active
        }
        
        physicsWorld.contactDelegate = self
        
        
    }
    
    @objc func startGenerator(){
        self.obstacleSpawner.generate(scene: self.scene!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nodeCheck = physicsWorld.body(alongRayStart: player.position, end: CGPoint(x: player.position.x, y: player.position.y + 100))
        if nodeCheck?.node == nil{
            player.stack(scene: scene!)
        }
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
        
        print("BodyA = \(bodyA.node?.name) : BodyB = \(bodyB.node?.name)" )
        
        if bodyA.categoryBitMask == PhysicsCategory.Barrier {
            if bodyB.categoryBitMask == PhysicsCategory.Obstacle {
                bodyB.node?.removeFromParent()
            }
            
        }
    if bodyB.categoryBitMask == PhysicsCategory.Barrier {
        if bodyA.categoryBitMask == PhysicsCategory.Obstacle {
                bodyA.node?.removeFromParent()
            }
            
        }
        
    }
    
    
    func checkBody(){
        
        if player.bodyNodes.count >= 1 {
            
            for sprite in player.bodyNodes {
                if sprite.position.x < player.position.x - 5 {
                    player.bodyNodes = player.bodyNodes.filter {return $0 != sprite }
                    let rotate = SKAction.rotate(byAngle: 25, duration: 1)
                    let pushBack = SKAction.moveTo(x: sprite.position.x - 400, duration: 0.7)
                    let remove = SKAction.run {
                        sprite.removeFromParent()
                    }
                    let group = SKAction.group([pushBack, rotate])
                    let seq = SKAction.sequence([group, remove])
                    sprite.run(SKAction.repeatForever(seq))
                }
            }
        }
    }
    
    func checkPlayer() {
        if player.position.x < player.initialPos.x - 10{
            let rotate = SKAction.rotate(byAngle: 15, duration: 2.5)
            let pushBack = SKAction.moveTo(x: player.position.x - 400, duration: 2)
            let seq = SKAction.group([pushBack, rotate])
            player.run(seq)
            gameState = .Menu
        } else {
            self.player.position.x = self.player.initialPos.x
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        scrollWorld()
        if gameState == .Active {
            checkBody()
            checkPlayer()
        }
    }
}
