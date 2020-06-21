//
//  Obstacle.swift
//  StacksOnStacks
//
//  Created by Wesley Espinoza on 2/14/20.
//  Copyright © 2020 Erick Espinoza. All rights reserved.
//

import Foundation
import SpriteKit

class Obstacle: SKSpriteNode {
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */
    var timePerCent: CFTimeInterval?
    var pointer = 0
    var currentScheme: [[Int]] = []
    
    let test: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 1, 0, 0, 0],
                         [0, 0, 0, 0, 1, 1, 0, 0, 0],
                         [0, 0, 0, 1, 1, 1, 0, 0, 0],
                         [0, 0, 1, 1, 1, 1, 0, 0, 0]]
    
    let testTwo: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0]]
    
    let testThree: [[Int]] = [[0, 0, 0, 1, 1, 0, 0, 0, 0],
                              [0, 0, 0, 1, 1, 0, 0, 0, 0],
                              [0, 0, 0, 1, 1, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 1, 1, 1, 1, 0, 0, 0],
                              [0, 0, 1, 1, 1, 1, 0, 0, 0],
                              [0, 0, 1, 1, 1, 1, 0, 0, 0]]
    
    let testFour: [[Int]] = [[0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0]]
    
    let testFive: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0]]
    
    let testSix: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0]]
    
    let testSeven: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 1, 1, 1, 1, 0, 0, 0],
                              [0, 0, 1, 0, 0, 1, 0, 0, 0],
                              [0, 0, 1, 0, 0, 1, 0, 0, 0],
                              [0, 0, 1, 1, 1 ,1, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0]]
    
    let testEight: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 0, 0, 0, 0, 0],
                              [0, 0, 0, 0, 1, 0, 0, 0, 0],
                              [0, 0, 0, 0, 1, 1, 0, 0, 0],
                              [0, 0, 0, 0, 1, 1, 1, 0, 0],
                              [0, 0, 0, 0, 1, 1, 1, 1, 0]]
    
    let testNine: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 0, 0, 0, 0, 0, 0],
                             [0, 0, 0, 1, 1, 1, 0, 0, 0],
                             [0, 0, 0, 1, 1, 1, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0],
                             [0, 0, 1, 1, 1, 1, 0, 0, 0]]
    
    
    
    let testTen: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 1, 0, 0, 0],
                            [0, 0, 0, 0, 0, 1, 0, 0, 0],
                            [0, 0, 0, 0, 1, 1, 0, 0, 0],
                            [0, 0, 0, 0, 1, 1, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0],
                            [0, 0, 1, 1, 1, 1, 0, 0, 0]]
    

    
     func generate(scene: SKScene){
        let schemes = [test, testTwo, testThree, testFour, testFive, testSix, testSeven, testEight, testNine, testTen]
        if timePerCent == nil {
            timePerCent = 0
            currentScheme = schemes.randomElement()!
            
            let child = self.children[0] as! SKSpriteNode
            let intialPos = self.children[0].position.x
            while child.position.x <= intialPos + child.size.width / 2 {
                child.position.x += 1.75
                timePerCent! += fixedDelta
            }
            child.position.x = intialPos
            
        }
        
        
        
        spawnTimer += fixedDelta
        if spawnTimer > Double(timePerCent!) {
            let copy = self.copy() as! SKSpriteNode
            copy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
            
            var column: [SKSpriteNode] = []
            
            for row in 0...currentScheme.count - 1 {
                if pointer > 8 {
                    pointer = 0
                    currentScheme = schemes.randomElement()!
                }
                let child = copy.childNode(withName: "spawnBlock-\(row)") as! SKSpriteNode
                if currentScheme[row][pointer] != 1 {
                    child.physicsBody?.categoryBitMask = PhysicsCategory.Invisible
                    child.physicsBody?.collisionBitMask = PhysicsCategory.None

                } else {
                    child.physicsBody?.affectedByGravity = false
                    child.physicsBody?.allowsRotation = false
                    child.physicsBody?.isDynamic = false
                    child.physicsBody?.density = 0
                    child.color = UIColor.random
                    child.colorBlendFactor = 0.5
                    child.position = scene.convert(child.position, to: scene)
                    child.position.x = child.position.x + 800
                    child.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
                    child.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Ground | PhysicsCategory.Obstacle
                    column.append(child.copy() as! SKSpriteNode)
                }
                
                
            }
            copy.removeAllChildren()
            copy.removeFromParent()
            
            let move = SKAction.moveBy(x: -100, y: 0, duration: 0.5)
            let repeater = SKAction.repeatForever(move)
            
            for copiedChild in column {
                if copiedChild.physicsBody?.categoryBitMask != PhysicsCategory.Invisible {
                    scene.addChild(copiedChild)
                    copiedChild.run(repeater)
                }

            }
            column = []
            
            spawnTimer = 0
            pointer += 1
        }
        
    }
    
}
extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
