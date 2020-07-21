//
//  MenuScene.swift
//  Bone_Toss
//
//  Created by Anthony Gonzalez on 10/1/19.
//  Copyright © 2019 Antnee. All rights reserved.
//

import Foundation

import SpriteKit

class MenuScene: SKScene {
    
    var easyButton = SKSpriteNode()
    var easyButtonTexture = SKTexture(imageNamed: "easy")
    
    var hardButton = SKSpriteNode()
    var hardButtonTexture = SKTexture(imageNamed: "hard")
    
    override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        easyButton = SKSpriteNode(texture: easyButtonTexture)
        easyButton.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        addChild(easyButton)
        
        hardButton = SKSpriteNode(texture: hardButtonTexture)
        hardButton.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        hardButton.setScale(0.5)
        addChild(hardButton)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == easyButton {
                let transition = SKTransition.fade(withDuration: 1)
                let scene = GameScene(size: self.size)
                scene.monsterSpeed = 1.3...3.6
                scene.musicString = "bgMusicEasy"
                scene.durationToWait = 1.4
                
                self.view?.presentScene(scene, transition: transition)
                
            } else if node == hardButton {
                let transition = SKTransition.fade(withDuration: 1)
                let scene = GameScene(size: self.size)
                scene.monsterSpeed = 0.8...1.9
                scene.musicString = "bgMusicHard"
                scene.durationToWait = 4.0
                
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
}

