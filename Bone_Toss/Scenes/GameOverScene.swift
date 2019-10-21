//
//  GameOverScene.swift
//  Bone_Toss
//
//  Created by Anthony Gonzalez on 10/1/19.
//  Copyright © 2019 Antnee. All rights reserved.
//

import Foundation

import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won:Bool) {
        super.init(size: size)
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let message = won ? "You Won!" : "You Lose"
        let label = SKLabelNode(fontNamed:"Monster Friend Fore")

        label.text = message
        label.fontSize = 40
        label.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() { [weak self] in
                guard let `self` = self else { return }
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = MenuScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
        ]))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
