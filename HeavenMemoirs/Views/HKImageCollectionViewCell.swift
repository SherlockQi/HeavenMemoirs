//
//  HKImageCollectionViewCell.swift
//  HeavenMemoirs
//
//  Created by HeiKki on 2017/10/17.
//  Copyright © 2017年 HeiKki. All rights reserved.
//

import UIKit

class HKImageCollectionViewCell: UICollectionViewCell {


    
    let imageView:UIImageView = UIImageView()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(frame: CGRect(x: contentView.bounds.width - 25, y: 2, width: 30, height: 30))
        button.setImage(UIImage(named: "photo_delete"), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonDidClick), for: .touchUpInside)

        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        imageView.frame = CGRect(x: 8, y: 4, width: frame.size.width - 8, height: frame.size.height - 16)
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        deleteButton.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellShake(shake:Bool){
        if shake{
            beginShake()
        }else{
            endShake()
        }
    }
    
   private func beginShake(){
        deleteButton.isHidden = false

        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 0.08
        animation.fromValue = -Float.pi/40
        animation.toValue = Float.pi/40
        animation.repeatCount =  Float(INT_MAX)
        animation.autoreverses = true
        self.imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.imageView.layer.add(animation, forKey: "cellShake")
    }
    
   private func endShake(){
         deleteButton.isHidden = true
        self.imageView.layer.removeAnimation(forKey: "cellShake")
    }
    @objc func deleteButtonDidClick(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notification_NAME_ImageDetele"), object: self)
    }
}
