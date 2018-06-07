//
//  HKTools.swift
//  HeavenMemoirs
//
//  Created by HeiKki on 2017/10/19.
//  Copyright © 2017年 HeiKki. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

class HKTools: NSObject {

    func toAppStore(vc:UIViewController){
        let alertController = UIAlertController(title: "可还满意?给我个评价吧！",
                                                message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "暂不评价", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default,
                                     handler: {
                                        action in
                                        self.gotoAppStore()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    func gotoAppStore() {
        let url = URL(string: "itms-apps://itunes.apple.com/cn/app/weare/id1304227680?action=write-review")
        UIApplication.shared.open(url!,options: [:], completionHandler: nil)
    }
    
    

    
    
}

