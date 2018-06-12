//
//  HKARSCNView.swift
//  HeavenMemoirs
//
//  Created by HeiKki on 2017/10/18.
//  Copyright © 2017年 HeiKki. All rights reserved.
//

import UIKit
import ARKit

class HKARSCNView: ARSCNView {
    let rescouceManager = RescouceManager.share
    let rescoucceConfiguration = RescouceConfiguration.share
    var videoPlayer: AVPlayer?
    lazy var musicPlayer: AVPlayer = {
        let  musicPlayer = AVPlayer()
        return musicPlayer
    }()
    ///环的半径
    let ringRadius: Float = 6.0
    func removeAllNodes() {
        for node in self.scene.rootNode.childNodes {
            node.removeFromParentNode()
        }
        videoPlayer = nil
        musicPlayer.pause()
        NotificationCenter.default.removeObserver(self)
    }
    func addPhotoRing_V(vector3: SCNVector3, left: CGFloat, L: Int) {
        let photoRingNode = SCNNode()
        photoRingNode.position = SCNVector3Zero
        self.scene.rootNode.addChildNode(photoRingNode)
        let photoW: CGFloat = 1.4
        let photoH: CGFloat = photoW/0.618
        let radius: CGFloat = 0.02
        for index in 0..<L {
            let photo = SCNPlane(width: photoW, height: photoH)
            photo.cornerRadius = radius
            let i = Int(index % rescouceManager.verticalImages.count)
            let image = RescouceManager.share.verticalImages[i]
            photo.firstMaterial?.diffuse.contents = image
            let photoNode = SCNNode(geometry: photo)
            photoNode.position = vector3
            let emptyNode = SCNNode()
            emptyNode.position = SCNVector3Zero
            emptyNode.rotation = SCNVector4Make(0, 1, 0, Float.pi/Float(L/2) * Float(index))
            emptyNode.addChildNode(photoNode)
            photoRingNode.addChildNode(emptyNode)
        }
        let ringAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: left, z: 0, duration: 10))
        photoRingNode.runAction(ringAction)
    }
    func addPhotoRing_H(vector3: SCNVector3, left: CGFloat, L: Int) {
        let photoRingNode = SCNNode()
        photoRingNode.position = SCNVector3Zero
        self.scene.rootNode.addChildNode(photoRingNode)
        let photoW: CGFloat       = 2.8
        let photoH: CGFloat       = photoW * 0.618
        let radius: CGFloat = 0.02
        for index in 0..<L {
            let photo = SCNPlane(width: photoW, height: photoH)
            photo.cornerRadius = radius
            let i = Int(index % rescouceManager.horizontalImages.count)
            let image = rescouceManager.horizontalImages[i]
            photo.firstMaterial?.diffuse.contents = image
            let photoNode = SCNNode(geometry: photo)
            photoNode.position = vector3
            let emptyNode = SCNNode()
            emptyNode.position = SCNVector3Zero
            emptyNode.rotation = SCNVector4Make(0, 1, 0, Float.pi/Float(L/2) * Float(index))
            emptyNode.addChildNode(photoNode)
            photoRingNode.addChildNode(emptyNode)
        }
        let ringAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: left, z: 0, duration: 10))
        photoRingNode.runAction(ringAction)
    }
    func addPhotoRing_Box(vector3: SCNVector3, left: CGFloat, L: Int) {
        let photoRingNode = SCNNode()
        photoRingNode.position = SCNVector3Zero
        self.scene.rootNode.addChildNode(photoRingNode)
        let boxW: CGFloat       = 0.36
        for index in 0..<L {
            let box = SCNBox(width: boxW, height: boxW, length: boxW, chamferRadius: 0)
            if rescoucceConfiguration.box_Random {
                let count = rescouceManager.boxImages.count
                var materials: [SCNMaterial] = []
                for _ in 0..<6 {
                    let i = Int(arc4random_uniform(UInt32(count)))
                    let image = rescouceManager.boxImages[i]
                    let material = SCNMaterial()
                    material.multiply.contents = image
                    materials.append(material)
                }
                box.materials = materials
            } else {
                let i = Int(index % rescouceManager.boxImages.count)
                let image = rescouceManager.boxImages[i]
                box.firstMaterial?.diffuse.contents = image
            }
            let boxNode = SCNNode(geometry: box)
            boxNode.position = vector3
            let emptyNode = SCNNode()
            emptyNode.position = SCNVector3Zero
            emptyNode.rotation = SCNVector4Make(0, 1, 0, Float.pi/Float(L/2) * Float(index))
            emptyNode.addChildNode(boxNode)
            photoRingNode.addChildNode(emptyNode)
            var right: CGFloat = left
            if index%2 == 1 { right = -left }
            let ringAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: right, z: 0, duration: 2))
            boxNode.runAction(ringAction)
        }
    }
    // MARK: 显示文字
    func addPhotoRing_Text(text: String, color: String) {
        let textRingNode = SCNNode()
        textRingNode.position = SCNVector3Zero
        self.scene.rootNode.addChildNode(textRingNode)
        var index: Int = 0
        var angle: Float = 0
        for t in text.characters {
            index += 1
            let str = String(t)
            let text = SCNText(string: str, extrusionDepth: 0.1)
            text.font = UIFont.systemFont(ofSize: 0.4)
            text.firstMaterial?.diffuse.wrapT = .repeat
            let textNode = SCNNode(geometry: text)
            textNode.position = SCNVector3Make(0, 0, -ringRadius)
            text.firstMaterial?.diffuse.contents = UIImage(named: color)
            let emptyNode = SCNNode()
            emptyNode.position = SCNVector3Zero
            emptyNode.rotation = SCNVector4Make(0, 1, 0, angle)
            emptyNode.addChildNode(textNode)
            textRingNode.addChildNode(emptyNode)
            let ii = UnsafePointer<Int8>(str)
            if 3 == strlen(ii) {
                angle += -Float.pi/Float(40)
            } else {
                angle += -Float.pi/Float(80)
            }
        }
        let ringAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: -1, z: 0, duration: 5))
        textRingNode.runAction(ringAction)
    }
    func addPhotoRing_Back(vector3: SCNVector3, left: CGFloat, L: Int) {
        let photoRingNode = SCNNode()
        photoRingNode.position = SCNVector3Zero
        self.scene.rootNode.addChildNode(photoRingNode)
        let photoW: CGFloat       = CGFloat(2*ringRadius*sin(Float.pi/Float(L)) - 0.5)
        let photoH: CGFloat       = photoW * 0.618
        let radius: CGFloat = 0
        for index in 0..<L {
            let photo = SCNPlane(width: photoW, height: photoH)
            photo.cornerRadius = radius
            let i = Int(index % rescouceManager.horizontalImages.count)
            let image = rescouceManager.horizontalImages[i]
            photo.firstMaterial?.diffuse.contents = image
            let photoNode = SCNNode(geometry: photo)
            photoNode.position = vector3
            let emptyNode = SCNNode()
            emptyNode.position = SCNVector3Zero
            emptyNode.rotation = SCNVector4Make(0, 1, 0, Float.pi/Float(L/2) * Float(index))
            emptyNode.addChildNode(photoNode)
            photoRingNode.addChildNode(emptyNode)
        }
        let ringAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: left, z: 0, duration: 20))
        photoRingNode.runAction(ringAction)
    }
    func addPanoramaImage(image: UIImage) {
        let sphere = SCNSphere(radius: 15)
        let sphereNode = SCNNode(geometry: sphere)
        sphere.firstMaterial?.isDoubleSided = true
        sphere.firstMaterial?.diffuse.contents = image
        sphereNode.position = SCNVector3Zero
        scene.rootNode.addChildNode(sphereNode)
    }
    func playVideo(url: URL) {
        let boxNode = SCNNode()
        if let videoSize = rescouceManager.videoImage?.size {
            var width: CGFloat = 2.0
            if videoSize.width > videoSize.height {
                width = 4.0
            }
            let height: CGFloat = CGFloat(width) * videoSize.height/videoSize.width
            let box = SCNBox(width: width, height: height, length: 0.3, chamferRadius: 0)
            boxNode.geometry = box
            boxNode.geometry?.firstMaterial?.isDoubleSided = true
            boxNode.position = SCNVector3Make(0, 0, -5)
            box.firstMaterial?.diffuse.contents = UIColor.red
            self.scene.rootNode.addChildNode(boxNode)

            let avplayer = AVPlayer(url: url)
            avplayer.volume = rescoucceConfiguration.video_isSilence ? 0.0 : 3.0
            videoPlayer = avplayer
            let videoNode = SKVideoNode(avPlayer: avplayer)
            NotificationCenter.default.addObserver(self, selector: #selector(playEnd(notify:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            videoNode.size = CGSize(width: 1600, height: 900)
            videoNode.position = CGPoint(x: videoNode.size.width/2, y: videoNode.size.height/2)
            videoNode.zRotation = CGFloat(Float.pi)
            let skScene = SKScene()
            skScene.addChild(videoNode)
            skScene.size = videoNode.size
            box.firstMaterial?.diffuse.contents = skScene
            videoNode.play()
        }
    }
    func playMusic(musicName: String) {
        //播放音乐
        if let resourceUrl = Bundle.main.url(forResource: musicName, withExtension: "aac") {
            if FileManager.default.fileExists(atPath: resourceUrl.path) {
                let item = AVPlayerItem(url: resourceUrl)
                musicPlayer.replaceCurrentItem(with: item)
                musicPlayer.play()
            }
        }
    }
    func addParticleSytem(type: Int) {
        let particleNode = SCNNode()
        var particleName: String = ""
        var Y: Float = 0
        switch type {
        case 0:
            particleName = "bokeh.scnp"
            Y = -2
        case 1:
            particleName = "rain.scnp"
            Y = 3
        case 2:
            particleName = "confetti.scnp"
            Y = 4
        default:break
        }
        if let particleSytem = SCNParticleSystem(named: particleName, inDirectory: nil) {
            particleNode.addParticleSystem(particleSytem)
            particleNode.position = SCNVector3Make(0, Y, 0)
            self.scene.rootNode.addChildNode(particleNode)
        }
    }
    @objc func playEnd(notify: Notification) {
        let item = notify.object as! AVPlayerItem
        if videoPlayer?.currentItem == item {
            videoPlayer?.seek(to: kCMTimeZero)
            videoPlayer?.play()
        } else if  musicPlayer.currentItem == item {
            musicPlayer.seek(to: kCMTimeZero)
            musicPlayer.play()
        }
    }
}
