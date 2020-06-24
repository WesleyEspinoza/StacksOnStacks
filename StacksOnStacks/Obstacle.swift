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
    let scrollSpeed = 0.3
    var pointer = 0
    var currentScheme: [[Int]] = []
    let schemes: Schemes = Schemes()
    
    func initSpaceTime(){
        if timePerCent == nil {
            timePerCent = 0
            let child = self.children[0] as! SKSpriteNode
            let initialPos = self.children[0].position.x
            let move = SKAction.move(by: CGVector(dx: 100, dy: 0), duration: scrollSpeed)
            child.run(move)
            let _ = Timer.scheduledTimer(timeInterval: fixedDelta, target: self, selector: #selector(timerCheck(_:)), userInfo: ["child":child, "pos":initialPos], repeats: true)
            currentScheme = schemes.getRandomScheme()
        }
    }
    
    @objc func timerCheck(_ timer: Timer){
        let info = timer.userInfo as! [String: Any]
        let child = info["child"] as! SKSpriteNode
        let initialPos = info["pos"] as! CGFloat
        if child.position.x <= initialPos + (child.size.width * 0.90) {
            timePerCent! += fixedDelta
        } else {
            timer.invalidate()
            child.removeAllActions()
            child.position.x = initialPos
            
        }
    }

    
     func generate(scene: SKScene){
        initSpaceTime()
        spawnTimer += fixedDelta
        if spawnTimer > Double(timePerCent!) {
            let copy = self.copy() as! SKSpriteNode
            
            var column: [SKSpriteNode] = []
            
            for row in 0...currentScheme.count - 1 {
                if pointer > currentScheme[row].count - 1 {
                    pointer = 0
                    currentScheme = schemes.getRandomScheme()
                }
                let child = copy.childNode(withName: "spawnBlock-\(row)") as! SKSpriteNode
                child.physicsBody?.categoryBitMask = PhysicsCategory.Invisible
                child.physicsBody?.collisionBitMask = PhysicsCategory.None
                if currentScheme[row][pointer] == 1 {
                    child.color = UIColor.random
                    child.colorBlendFactor = 0.7
                    child.position = scene.convert(child.position, to: scene)
                    let scenePos = scene.convertPoint(fromView: copy.position)
                    child.position.x = scenePos.x + child.size.width
                    child.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
                    child.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Ground | PhysicsCategory.Obstacle
                    column.append(child.copy() as! SKSpriteNode)

                }
            }
            copy.removeAllChildren()
            copy.removeFromParent()
            
            let move = SKAction.moveBy(x: -100, y: 0, duration: scrollSpeed)
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
