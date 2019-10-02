//
//  PhysicsCategory.swift
//  Bone_Toss
//
//  Created by Anthony Gonzalez on 10/1/19.
//  Copyright © 2019 Antnee. All rights reserved.
//

import Foundation

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let enemy   : UInt32 = 0b1
  static let projectile: UInt32 = 0b10
}
