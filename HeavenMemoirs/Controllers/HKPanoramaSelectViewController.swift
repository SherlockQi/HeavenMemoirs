//
//  HKPanoramaSelectViewController.swift
//  HeavenMemoirs
//
//  Created by HeiKki on 2017/10/22.
//  Copyright © 2017年 HeiKki. All rights reserved.
//

import UIKit
import ARKit

class HKPanoramaSelectViewController: UIViewController {
    @IBOutlet weak var arSCNView: ARSCNView!
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    let  imageNames:[String] = ["panorama_0",
                                "panorama_1",
                                "panorama_2",
                                "panorama_3",
                                "panorama_4",
                                "panorama_5",
                                "panorama_6",
                                "panorama_7",
                                "panorama_8",
                                "panorama_9",
                                "panorama_10",
                                "panorama_11",
                                "panorama_12"]
    let sphere = SCNSphere(radius: 10)
    var index: Int = 0{
        didSet{
            nextButton.isHidden = index == imageNames.count - 1
            lastButton.isHidden = index == 0
            if index >= 0 && index < imageNames.count{
                if let newImage = UIImage(named: imageNames[index]){
                    image = newImage
                }
            }
        }
    }
    var image: UIImage = UIImage(){
        didSet{
            sphere.firstMaterial?.diffuse.contents = image
        }
    }
    class  func vc() -> HKPanoramaSelectViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HKPanoramaSelectViewController")
        return vc as! HKPanoramaSelectViewController
    }
    @IBAction func lastButtonDidClick(_ sender: UIButton) {
        index -= 1
    }
    @IBAction func nextButtonDidClick(_ sender: UIButton) {
        index += 1
    }
    @IBAction func completeButtonDidClick(_ sender: UIButton) {
    let manager = RescouceManager.share
        manager.panoramaImage = image
        navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        arSCNView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arSCNView.session.pause()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        index = 0
        let sphereNode = SCNNode(geometry: sphere)
        sphere.firstMaterial?.isDoubleSided = true
        if let imageName = imageNames.first{
            sphere.firstMaterial?.diffuse.contents = UIImage(named: imageName)
        }
        sphereNode.position = SCNVector3Zero
        arSCNView.scene.rootNode.addChildNode(sphereNode)
    }
    
}
