//
//  Map.swift
//  SandStorm
//
//  Created by Matt Finch on 7/12/19.
//  Copyright © 2019 Matt Finch. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Map: NSObject {
    
    var cactus: [SKSpriteNode]!
    var dunes: [SKShapeNode]!
    var mapNum: Int!
    var row: Int!
    var col: Int!
    var mapX: CGFloat!
    var mapY: CGFloat!
    
    func initMap(r: Int, c: Int) {
        cactus = [SKSpriteNode]()
        row = r
        col = c
        for _ in 0...3 {
            createCactus()
        }
    }
    
    func resetMap() {
        for i in 0..<cactus.count {
            cactus[i].position = randomPoint()
        }
    }
    
    func moveMap(mx: CGFloat, my: CGFloat) {
        for i in 0 ..< cactus.count {
            cactus[i].position.x += mx
            cactus[i].position.y += my
        }
//        mapX += mx
//        mapY += my
    }
    
    func createCactus() {
        let c = SKSpriteNode(imageNamed: "cactus")
        c.position = randomPoint()
        c.size = CGSize(width: GameScene.phoneSize.width * 0.04, height: GameScene.phoneSize.width * 0.04 * c.size.height / c.size.width)
        c.zPosition = 2
        cactus.append(c)
    }
    
    func randomPoint() -> CGPoint {
        var cx = CGFloat.random(in: 0...GameScene.phoneSize.width) - GameScene.phoneSize.width / 2
        var cy = CGFloat.random(in: 0...GameScene.phoneSize.height) - GameScene.phoneSize.height / 2
        var spread = false
        while !spread && cactus.count > 0 {
            spread = true
            cx = CGFloat.random(in: 0...GameScene.phoneSize.width) - GameScene.phoneSize.width / 2
            cy = CGFloat.random(in: 0...GameScene.phoneSize.height) - GameScene.phoneSize.height / 2
            for i in 0...cactus.count - 1 {
                if abs(cx - cactus[i].position.x) < GameScene.phoneSize.width * 0.1 {
                    spread = false
                } else if (abs(cy - cactus[i].position.y) < GameScene.phoneSize.height * 0.1) {
                    spread = false
                }
            }
        }
        cx += CGFloat(row - 1) * GameScene.phoneSize.width
        cy += CGFloat(col - 1) * GameScene.phoneSize.height
        return CGPoint(x: cx, y: cy)
    }
    
    
}
