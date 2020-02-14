//
//  Stackable.swift
//  StacksOnStacks
//
//  Created by Wesley Espinoza on 2/14/20.
//  Copyright © 2020 Erick Espinoza. All rights reserved.
//

import Foundation
import SpriteKit

class Stackable: SKSpriteNode{
    var canStack: Bool = true
    func stack(scene: SKScene){
        
        if canStack {
            canStack = false
              let body = SKSpriteNode(color: .cyan, size: CGSize(width: 100, height: 100))
              body.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
              body.physicsBody?.allowsRotation = false
              body.physicsBody?.isDynamic = true
              body.physicsBody?.affectedByGravity = true

              let vector = CGVector(dx: 0, dy: self.size.height * 2.5)
              let jump = SKAction.run {
                  self.physicsBody?.applyImpulse(vector)
                  for child in self.children {
                      child.physicsBody?.applyImpulse(vector)
                  }
              }
            
              let wait = SKAction.wait(forDuration: 0.3)
              let addChild = SKAction.run {
                  if self.children.count < 1 {
                      body.position = scene.convert(CGPoint(x: self.position.x, y: self.position.y - self.size.height), to: self)
                  } else {
                      body.position = CGPoint(x: self.children[self.children.count - 1].position.x, y: self.children[self.children.count - 1].position.y - self.size.height)
                  }
                  self.addChild(body)
              }
            let smallWait = SKAction.wait(forDuration: 0.1)
            
            let enableStack = SKAction.run {
                self.canStack = true
            }

              let sequence = SKAction.sequence([jump, wait, addChild, smallWait, enableStack])
              self.run(sequence)
            
        }

    }
}
