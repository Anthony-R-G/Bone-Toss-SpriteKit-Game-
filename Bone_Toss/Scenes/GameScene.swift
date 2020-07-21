//
//  GameScene.swift
//  Bone_Toss
//
//  Created by Anthony Gonzalez on 10/1/19.
//  Copyright © 2019 Antnee. All rights reserved.
//

import Foundation
import UIKit

import SpriteKit

class GameScene: SKScene {
    let player = SKSpriteNode(imageNamed: "player")
    var scoreLabel: SKLabelNode!
    var monstersDestroyed = 0
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var gameOver = false
    
    var monsterSpeed: ClosedRange<CGFloat> = 1.3...3.5
    
    var musicString = String()
    
    var durationToWait = Double()
    
    
    private func setPlayer() {
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(player)
        player.zPosition = 1
    }
    
    private func configBackground() {
        let backgroundMusic = SKAudioNode(fileNamed: musicString)
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        let backgroundImage = SKSpriteNode(imageNamed: "background.jpg")
        backgroundImage.size = self.frame.size
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(backgroundImage)
    }
    
    private func configScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Monster Friend Fore")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 650 , y: 380)
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
       
    }
    
    private func configPhysicsWorld() {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    override func didMove(to view: SKView) {
        setPlayer()
        configPhysicsWorld()
        createEndlessMonsterSpawn()
        configBackground()
        configScoreLabel()
        print(monsterSpeed)
    }
    
    private func addEnemy() {
        let enemy = SKSpriteNode(imageNamed: "monster")
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.none
        let y_axisSpawn = CGFloat.random(in: enemy.size.height/2...size.height - enemy.size.height/2)
        enemy.position = CGPoint(x: size.width + enemy.size.width/2, y: y_axisSpawn)
        enemy.zPosition = 1
        addChild(enemy)
        
        let actionMove = SKAction.move(to: CGPoint(x: -enemy.size.width/2, y: y_axisSpawn),
                                       duration: TimeInterval(CGFloat.random(in: monsterSpeed)))
        let actionMoveDone = SKAction.removeFromParent()
        
        let loseAction = SKAction.run() { [weak self] in
            guard let `self` = self else { return }
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
        enemy.run(SKAction.sequence([SKAction.wait(forDuration: durationToWait), actionMove, loseAction,
                      SKAction.playSoundFileNamed("laugh.wav", waitForCompletion: false), actionMoveDone]))
    }
    
    private func createEndlessMonsterSpawn() {
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addEnemy),
                SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        let offset = touchLocation - projectile.position
        if offset.x < 0 { return }
        addChild(projectile)
        projectile.zPosition = 1
        
        let direction = offset.normalized()
        let shotDistance = direction * 1000
        let destination = shotDistance + projectile.position
        let actionMove = SKAction.move(to: destination, duration: 1.8)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove,actionMoveDone]))
        
        run(SKAction.playSoundFileNamed("bark.wav", waitForCompletion: false))
    }
    
   private func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        [projectile, monster].forEach{$0.removeFromParent()}
        run(SKAction.playSoundFileNamed("hit.wav", waitForCompletion: false))
        score += 1
        if score > 50 {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            view?.presentScene(gameOverScene, transition: reveal)
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if ((firstBody.categoryBitMask & PhysicsCategory.enemy != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
            if let monster = firstBody.node as? SKSpriteNode,
                let projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
    }
}
