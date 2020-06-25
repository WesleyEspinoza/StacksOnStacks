//
//  Player.swift
//  StacksOnStacks
//
//  Created by Wesley Espinoza on 2/14/20.
//  Copyright © 2020 Erick Espinoza. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    var canStack: Bool = true
    let maxStack: Int = 7
    var bodyNodes: [SKSpriteNode] = []
    var initialPos: CGPoint!
    
    func stack(scene: SKScene){
        
        if canStack && bodyNodes.count <= maxStack{
            canStack = false
            let body = SKSpriteNode(color: .cyan, size: CGSize(width: 100, height: 100))
            body.texture = SKTexture(imageNamed: "egg")
            body.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
            body.physicsBody?.allowsRotation = false
            body.physicsBody?.isDynamic = true
            body.physicsBody?.affectedByGravity = true
            body.physicsBody?.categoryBitMask = PhysicsCategory.PlayerBody
            body.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle
            body.physicsBody?.collisionBitMask =  PhysicsCategory.Obstacle | PhysicsCategory.PlayerBody
            
            
            
            let jump = SKAction.moveTo(y: self.position.y + self.size.height + 10, duration: 0.1)
            
            
            let addChild = SKAction.run {
                body.position = scene.convert(CGPoint(x: self.position.x , y: self.position.y - (self.size.height + 5)), to: scene)
                self.bodyNodes.append(body)
                scene.addChild(body)
            }
            
            let smallWait = SKAction.wait(forDuration: 0.03)
            
            let enableStack = SKAction.run {
                self.canStack = true
            }
            
            
            let sequence = SKAction.sequence([jump, addChild, smallWait, enableStack])
            self.run(sequence)
        }
        
    }
    
    func setup(){
        self.texture = SKTexture(imageNamed: "head")
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Ground | PhysicsCategory.PlayerBody
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle
        self.initialPos = self.position
        
    }
}

