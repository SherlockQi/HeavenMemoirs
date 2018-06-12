//
//  RescouceManager.swift
//  HeavenMemoirs
//
//  Created by HeiKki on 2017/10/17.
//  Copyright © 2017年 HeiKki. All rights reserved.
//

import UIKit

class RescouceManager: NSObject, NSCoding {
    // 单例
    static let share = RescouceManager.init()
    private override init() {}
    //方形图片
    var boxImages: [UIImage] = []
    //水平图片
    var horizontalImages: [UIImage] = []
    //垂直图片
    var verticalImages: [UIImage] = []
    ///全景图
    var panoramaImage: UIImage?
    //视频缩略图
    var videoImage: UIImage?
    var videoURL: URL?
    ///粒子
    var particleType: Int = 2
    ///背景音乐
     var musicName: String?
    ///文字
    var text: String?
    var textColor: String?
    //------盒子图片 要求 1:1-----//
    func addBoxImage(image: UIImage) {
        boxImages.append(image)
    }
    func deleteBoxImage(image: UIImage) {
        if boxImages.index(of: image) != NSNotFound {
            boxImages.remove(at: boxImages.index(of: image)!)
        }
    }
    //------横向图片 要求 1:0.618-----//
    func addHorizontalImage(image: UIImage) {
        horizontalImages.append(image)
    }
    func deleteHorizontalImage(image: UIImage) {
        if horizontalImages.index(of: image) != NSNotFound {
            horizontalImages.remove(at: horizontalImages.index(of: image)!)
        }
    }
    //------竖直图片 要求 0.618:1-----//
    func addVerticalImage(image: UIImage) {
        verticalImages.append(image)
    }
    func deleteVerticalImage(image: UIImage) {
        if verticalImages.index(of: image) != NSNotFound {
            verticalImages.remove(at: verticalImages.index(of: image)!)
        }
    }
    // MARK: 归档&解档
    required init?(coder aDecoder: NSCoder) {
        //方形
       if let aDecoder_boxImages = aDecoder.decodeObject(forKey: k_R_boxImages) as? [UIImage] {
             boxImages = aDecoder_boxImages
       } else {
            boxImages = []
        }
        //水平
        if let aDecoder_horizontalImages = aDecoder.decodeObject(forKey: k_R_horizontalImages) as? [UIImage] {
            horizontalImages = aDecoder_horizontalImages
        } else {
            horizontalImages = []
        }
        //垂直
        if let aDecoder_verticalImages = aDecoder.decodeObject(forKey: k_R_verticalImages) as? [UIImage] {
            verticalImages = aDecoder_verticalImages
        } else {
            verticalImages = []
        }
        //全景图
        panoramaImage = aDecoder.decodeObject(forKey: k_R_panoramaImage) as? UIImage
        //视频
        videoImage  = aDecoder.decodeObject(forKey: k_R_videoImage) as? UIImage
        videoURL    = aDecoder.decodeObject(forKey: k_R_videoURL) as? URL
        //文字
        text        = aDecoder.decodeObject(forKey: k_R_text) as? String
        textColor   = aDecoder.decodeObject(forKey: k_R_textColor) as? String
        //粒子
        particleType = aDecoder.decodeInteger(forKey: k_R_particleType)
        //音乐
        musicName = aDecoder.decodeObject(forKey: k_R_musicName) as? String
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.boxImages, forKey: k_R_boxImages)
        aCoder.encode(self.horizontalImages, forKey: k_R_horizontalImages)
        aCoder.encode(self.verticalImages, forKey: k_R_verticalImages)
        aCoder.encode(self.panoramaImage, forKey: k_R_panoramaImage)
        aCoder.encode(self.videoImage, forKey: k_R_videoImage)
        aCoder.encode(self.videoURL, forKey: k_R_videoURL)
        aCoder.encode(self.text, forKey: k_R_text)
        aCoder.encode(self.textColor, forKey: k_R_textColor)
        aCoder.encode(self.particleType, forKey: k_R_particleType)
        aCoder.encode(self.musicName, forKey: k_R_musicName)
    }
}
