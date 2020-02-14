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
    static let Coin: UInt32 = 0b1000
    static let Barrier: UInt32 = 0b0000
}

enum GameState: Equatable {
    case Paused
    case active
    case GameOver
    case Menu
    
}

class GameScene: SKScene {
    
    var gameState = GameState.Menu
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */
    let scrollSpeed: CGFloat = 100
    var scrollLayer: SKNode!
    var groundOffset: CGFloat = 2
    var player: Player!

    
    
    
    override func sceneDidLoad() {
        player = self.childNode(withName: "player") as? Player
        scrollLayer = self.childNode(withName: "scrollLayer")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stack(scene: scene!)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        
    }
    

    
    
    func scrollWorld(offset: CGFloat) {
        /* Scroll World */
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through scroll layer nodes */
        for ground in scrollLayer.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space */
            let groundPosition = scrollLayer.convert(ground.position, to: self)
            
            /* Check if ground sprite has left the scene */
            if groundPosition.x <= -ground.size.width / 2 {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPoint(x: (self.size.width / 2) + (ground.size.width * offset), y: groundPosition.y)
                
                /* Convert new node position back to scroll layer space */
                ground.position = self.convert(newPosition, to: scrollLayer)
                
            }
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        scrollWorld(offset: groundOffset)
        
    }
}
