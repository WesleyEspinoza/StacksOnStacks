//
//  Obstacle.swift
//  StacksOnStacks
//
//  Created by Wesley Espinoza on 2/14/20.
//  Copyright © 2020 Erick Espinoza. All rights reserved.
//

import Foundation
import SpriteKit

class Obstacle: Stackable {
    
    func generate(scene: SKScene){
        let parent = self.parent?.parent as! GameScene
        while parent.gameState == .active {
            spawnTimer+=fixedDelta
            stack(scene: scene)
        }
        
        self.stack(scene: scene)
    }
}
