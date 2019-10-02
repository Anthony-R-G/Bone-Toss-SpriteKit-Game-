//
//  ViewController.swift
//  Bone_Toss
//
//  Created by Anthony Gonzalez on 10/1/19.
//  Copyright © 2019 Antnee. All rights reserved.
//

import UIKit

import SpriteKit

class GameViewController: UIViewController {
  
  private func createGameSceneInstance() {
    let scene = MenuScene(size: view.bounds.size)
    let skView = view as! SKView
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.ignoresSiblingOrder = true
    scene.scaleMode = .resizeFill
    skView.presentScene(scene)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createGameSceneInstance()
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
}


