//
//  AppDelegate.swift
//  HeavenMemoirs
//
//  Created by HeiKki on 2017/9/24.
//  Copyright © 2017年 HeiKki. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Bugly.start(withAppId: "67af4afe21")
        initRescouceManager()

        //友盟
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = "59f9a972aed1796cac00002b"
        
        UMSocialManager.default().platformProvider(with: UMSocialPlatformType.wechatSession).umSocial_setAppKey!("wx74fc8e42e38ce235", withAppSecret: "8a42834873fc2929580cf328a856da41", withRedirectURL: "")
        UMSocialManager.default().platformProvider(with: UMSocialPlatformType.wechatTimeLine).umSocial_setAppKey!("wx74fc8e42e38ce235", withAppSecret: "8a42834873fc2929580cf328a856da41", withRedirectURL: "")

        UMSocialManager.default().platformProvider(with: UMSocialPlatformType.QQ).umSocial_setAppKey!("1106120869", withAppSecret: "2HqDWO1cHR8L4Poe", withRedirectURL: "")
    
        UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.qzone)
       

        return true
    }
    
    func initRescouceManager(){
        let rescouceManager = RescouceManager.share
        var path=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        path+="/RescouceManager"
        
        if let manager = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? RescouceManager{
            for image in manager.boxImages {
                rescouceManager.addBoxImage(image: image)
            }
            for image in manager.horizontalImages {
                rescouceManager.addHorizontalImage(image: image)
            }
            for image in manager.verticalImages {
                rescouceManager.addVerticalImage(image: image)
            }
            rescouceManager.panoramaImage = manager.panoramaImage
            rescouceManager.videoURL = manager.videoURL
            rescouceManager.videoImage = manager.videoImage
            rescouceManager.text = manager.text
            rescouceManager.textColor = manager.textColor
            rescouceManager.particleType = manager.particleType
            rescouceManager.musicName = manager.musicName
        }
        
        var  rescouceConfigurationManager = RescouceConfiguration.share
        var c_path=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        c_path+="/RescouceConfiguration"
        if let configurationManager = NSKeyedUnarchiver.unarchiveObject(withFile: c_path) as? RescouceConfiguration{
            rescouceConfigurationManager.box_Random         = configurationManager.box_Random
            rescouceConfigurationManager.panorama_isShow    = configurationManager.panorama_isShow
            rescouceConfigurationManager.video_isPlay       = configurationManager.video_isPlay
            rescouceConfigurationManager.video_isSilence    = configurationManager.video_isSilence
            rescouceConfigurationManager.voice_isPlay       = configurationManager.voice_isPlay
            rescouceConfigurationManager.text_isShow        = configurationManager.text_isShow
            rescouceConfigurationManager.particle_isShow    = configurationManager.particle_isShow
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}


