//
//  GameScene.swift
//  SandStorm
//
//  Created by Matt Finch on 3/12/19.
//  Copyright © 2019 Matt Finch. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameLogo: SKNode!
    var bestScore: SKLabelNode!
    var playButton: SKNode!
    var background: SKSpriteNode!
    var shapeBackground: SKShapeNode!
    var car: SKSpriteNode!
    var control: SKSpriteNode!
    var subControl: SKSpriteNode!
    var prevAngle: CGFloat!
    var a: CGFloat!
    var s: CGFloat!
    var velocity: CGFloat!
    var tracks: [SKSpriteNode]!
    var tracksRight: [SKSpriteNode]!
    var time: Double!
    static var phoneSize: CGSize!
    var maps: [Map]!
    var peakVelocity: CGFloat!

    
    override func didMove(to view: SKView) {
        GameScene.phoneSize = self.size
        initializeMenu()
    }

    override func touchesMoved (_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            let controlLocation = control.position
            
            let x = location.x
            let y = location.y
            let r = control.size.width * 0.4
            
            let dX = pow(location.x - controlLocation.x, 2)
            let dY = pow(location.y - controlLocation.y, 2)
            let distance = pow(dX + dY, 0.5)
            
            let a = x * r / distance
            let b = (y - controlLocation.y) * r / distance
            
            var angle = CGFloat(0)
            
            
            
            if distance < r {
                subControl.position = location
                angle = atan((y - controlLocation.y) / x)
                
            } else {
                subControl.position = CGPoint(x: a, y: controlLocation.y + b)
                angle = atan(b / a)
            }
            
            angle -= CGFloat(Double.pi / 2)
            if x < 0 {
                angle += CGFloat(Double.pi)
            }
            
            var rotation = angle - prevAngle
            
            if rotation > CGFloat(Double.pi) || rotation < CGFloat(Double.pi * -1) {
                if rotation > 0 {
                    rotation -= CGFloat(Double.pi * 2)
                } else {
                    rotation += CGFloat(Double.pi * 2)
                }
            }
            
//            if angle - prevAngle < CGFloat(Double.pi * -1) {
//                rotation =
//            }
//            car.zRotation = angle
            var d = 0.5
            if abs(rotation) > 2 {
                d =  0.7
            }
            car.run(SKAction.rotate(byAngle: rotation, duration: d))
            prevAngle = angle


            if car.zRotation > CGFloat(Double.pi) {
                car.zRotation -= CGFloat(Double.pi * 2)
            } else if car.zRotation < CGFloat(Double.pi * -1) {
                car.zRotation += CGFloat(Double.pi * 2)
            }

        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        subControl.position = CGPoint(x: 0, y: self.size.height * -0.35)
    }
    
    override func update(_ currentTime: TimeInterval) {
//        print(car.zRotation)
        let angle = car.zRotation - CGFloat(Double.pi / 2)
        let moveX = velocity * cos(angle)
        let moveY = velocity * sin(angle)
        
        if velocity < peakVelocity {
            velocity += 0.065
        }
        
        for i in 0 ..< maps.count {
            maps[i].moveMap(mx: moveX, my: moveY)
            for c in maps[i].cactus {
                if car.intersects(c) {
                    velocity -= 4
                    c.position.y = self.size.height * 10
                }
            }
        }
        
        
//        background.position.x += moveX
//        background.position.y += moveY
        
        time += 1
        
//        if time.truncatingRemainder(dividingBy: 100) == 0 
            tireTracks()
        
//
//        for track in tracks {
//            track.position.x += x
//            track.position.y += y
//        }
//
//        for track in tracksRight {
//            track.position.x += x
//            track.position.y += y
//        }
        
    }
    
    private func initializeMenu() {
        shapeBackground = SKShapeNode(rect: CGRect(origin: CGPoint(x: -self.size.width / 2, y: -self.size.height/2), size: self.size))
        shapeBackground.fillColor = UIColor(red: CGFloat(234.0/255.0), green: CGFloat(180.0/255.0), blue: CGFloat(108.0/255.0), alpha: 1.0)
        shapeBackground.zPosition = 0
        self.addChild(shapeBackground)
        
//        background = SKSpriteNode(imageNamed: "BackgroundDots")
//        background.position = CGPoint(x: 0, y: 0)
//        background.zPosition = 1
//        self.addChild(background)
        
        car = SKSpriteNode(imageNamed: "car")
        car.size = CGSize(width: self.size.width * 0.08, height: self.size.width * 0.15)
        car.position = CGPoint(x: 0, y: 0)
        // car.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.6)
        car.zPosition = 4
        self.addChild(car)
        
        control = SKSpriteNode(imageNamed: "control")
        control.size = CGSize(width: self.size.width * 0.3, height: self.size.width * 0.3)
        control.position = CGPoint(x: 0, y: self.size.height * -0.35)
        control.zPosition = 2
        self.addChild(control)
        
        subControl = SKSpriteNode(imageNamed: "control")
        subControl.size = CGSize(width: self.size.width * 0.2, height: self.size.width * 0.2)
        subControl.position = CGPoint(x: 0, y: self.size.height * -0.35)
        subControl.zPosition = 3
        self.addChild(subControl)
        
        prevAngle = CGFloat(0)
        car.zRotation = CGFloat(0)
        a = car.zRotation
        
        time = 0.0
        velocity = CGFloat(12)
        peakVelocity = velocity
        tracks = [SKSpriteNode]()
        tracksRight = [SKSpriteNode]()
        
        maps = [Map]()
        for i in 0...2 {
            for j in 0...2 {
                let m = Map()
                m.initMap(r: i, c: j)
                for i in 0 ... m.cactus.count - 1 {
                    self.addChild(m.cactus[i])
                }
                maps.append(m)
            }
        }
        
        
        
    }
    
    private func tireTracks() {
//        let track = SKSpriteNode(imageNamed: "track")
//        let trackRight = SKSpriteNode(imageNamed: "track")
//        track.size = CGSize(width: car.size.width * 0.1, height: car.size.width * 0.1)
//        track.position = car.position
//
//        trackRight.size = CGSize(width: car.size.width * 0.1, height: car.size.width * 0.1)
//        trackRight.position = car.position
//
//        //        let angle = car.zRotation - CGFloat(Double.pi / 2)
//        let angle = car.zRotation
//        track.position.x += car.size.height * 0.3 * sin(angle)
//        track.position.y -= car.size.height * 0.3 * cos(angle)
//
//        trackRight.position.x += car.size.height * 0.3 * sin(angle)
//        trackRight.position.y -= car.size.height * 0.3 * cos(angle)
//
//        let angleTires = angle - CGFloat(Double.pi / 4)
//
//        track.position.x += car.size.width * 0.3 * sin(angleTires)
//        track.position.y -= car.size.width * 0.3 * cos(angleTires)
//        track.zPosition = 3
//        tracks.append(track)
//
//        trackRight.position.x -= car.size.width * 0.3 * sin(angleTires)
//        trackRight.position.y += car.size.width * 0.3 * cos(angleTires)
//        trackRight.zPosition = 3
//        tracksRight.append(trackRight)
//
//        self.addChild(tracks[tracks.endIndex - 1])
//        self.addChild(tracksRight[tracksRight.endIndex - 1])
//
//        if tracks.count >= 20 {
//            let action = SKAction.fadeOut(withDuration: 1)
//            tracks[tracks.count - 20].run(action)
//        }
//
//        if tracksRight.count >= 20 {
//            let action = SKAction.fadeOut(withDuration: 1)
//            tracksRight[tracksRight.count - 20].run(action)
//        }
//
//        if tracks.count > 0 {
//            tracks.removeFirst()
//        }
//
//        if tracksRight.count > 0 {
//            tracksRight.removeFirst()
//        }
    }

}
