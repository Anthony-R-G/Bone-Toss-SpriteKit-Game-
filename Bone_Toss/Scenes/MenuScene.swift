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
    
    var playButton = SKSpriteNode()
    var playButtonTexture = SKTexture(imageNamed: "play")
    
    override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        playButton = SKSpriteNode(texture: playButtonTexture)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playButton)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                let pos = touch.location(in: self)
                let node = self.atPoint(pos)

                if node == playButton {
                    if let view = view {
                        let transition:SKTransition = SKTransition.fade(withDuration: 1)
                        let scene:SKScene = GameScene(size: self.size)
                        self.view?.presentScene(scene, transition: transition)
                    }
                }
            }
        }
    }

