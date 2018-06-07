//
//  ViewController.swift
//  HeavenMemoirs
//
//  Created by HeiKki on 2017/9/24.
//  Copyright © 2017年 HeiKki. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController{
    @IBAction func supportButtonDidClick(_ sender: UIButton) {
        HKTools().toAppStore(vc: self)
    }
    @IBAction func beginButtonDidClick(_ sender: UIButton) {
        self.permissions()
    }
    
    let pscope = PermissionScope()
    // MARK:选择全景
    @IBAction func selectPanoramaButtonDidClick(_ sender: UIButton) {
        let rescoucceConfiguration = RescouceConfiguration.share
        if rescoucceConfiguration.show() {
            let musicVc = HKPanoramaSelectViewController.vc()
            self.navigationController?.pushViewController(musicVc, animated: true)
        }else{
            ITTPromptView.showMessage("功能开发中,敬请期待", andFrameY: 0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pscope.addPermission(CameraPermission(),message: "\r相机是通往AR世界的钥匙")
        let manager = RescouceManager.share
        if manager.boxImages.count == 0{
            manager.addBoxImage(image: UIImage(named: "B_Image_0")!)
            manager.addBoxImage(image: UIImage(named: "B_Image_1")!)
            manager.addBoxImage(image: UIImage(named: "B_Image_2")!)
            manager.addBoxImage(image: UIImage(named: "B_Image_3")!)
            manager.addBoxImage(image: UIImage(named: "B_Image_4")!)
        }
        
        if manager.verticalImages.count == 0{
            manager.addVerticalImage(image: UIImage(named: "V_Image_0")!)
            manager.addVerticalImage(image: UIImage(named: "V_Image_1")!)
            manager.addVerticalImage(image: UIImage(named: "V_Image_2")!)
            manager.addVerticalImage(image: UIImage(named: "V_Image_3")!)
            manager.addVerticalImage(image: UIImage(named: "V_Image_4")!)
            manager.addVerticalImage(image: UIImage(named: "V_Image_5")!)
        }
        if manager.horizontalImages.count == 0{
            manager.addHorizontalImage(image: UIImage(named: "H_Image_0")!)
            manager.addHorizontalImage(image: UIImage(named: "H_Image_1")!)
            manager.addHorizontalImage(image: UIImage(named: "H_Image_2")!)
            manager.addHorizontalImage(image: UIImage(named: "H_Image_3")!)
            manager.addHorizontalImage(image: UIImage(named: "H_Image_4")!)
            manager.addHorizontalImage(image: UIImage(named: "H_Image_5")!)
            manager.addHorizontalImage(image: UIImage(named: "H_Image_6")!)
        }
        
        if manager.text == nil{
            if  manager.text?.count == 0{
                manager.text = "嗨,你好呀!"
                manager.textColor = "textColor_0"
            }
        }
    }
}
// 判断权限
extension ViewController{
    func permissions(){
        pscope.show(
            { finished, results in
                self.pscope.hide()
                let videoAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
                switch videoAuthStatus {
                case .notDetermined: break//未询问
                case .denied: break//已悲剧
                default:
                    let sb = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "HKMemoirsViewController")
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                }
        },
            cancelled: { results in
                print("thing was cancelled")
                self.pscope.hide()
        }
        )
    }
}


