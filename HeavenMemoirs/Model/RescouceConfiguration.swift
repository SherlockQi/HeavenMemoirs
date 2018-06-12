//
//  RescouceConfiguration.swift
//  HeavenMemoirs
//
//  Created by HeiKki on 2017/10/22.
//  Copyright © 2017年 HeiKki. All rights reserved.
//

import UIKit

class RescouceConfiguration: NSObject, NSCoding {
    // 单例
    static let share = RescouceConfiguration.init()
    private override init() {}
    let showShow: Int = 20180106
    ///box 图片是否随机
    var box_Random: Bool              = false
    ///全景图
    var panorama_isShow: Bool         = false
    ///视频
    var video_isPlay: Bool            = false
    ///视频静音
    var video_isSilence: Bool         = false
    ///背景音乐
    var voice_isPlay: Bool            = false
    ///文字
    var text_isShow: Bool             = false
    ///粒子
    var particle_isShow: Bool         = true
    func encode(with aCoder: NSCoder) {
        aCoder.encode(box_Random, forKey: k_C_box_Random)
        aCoder.encode(panorama_isShow, forKey: k_C_panorama_isShow)
        aCoder.encode(video_isPlay, forKey: k_C_video_isPlay)
        aCoder.encode(video_isSilence, forKey: k_C_video_isSilence)
        aCoder.encode(voice_isPlay, forKey: k_C_voice_isPlay)
        aCoder.encode(text_isShow, forKey: k_C_text_isShow)
        aCoder.encode(particle_isShow, forKey: k_C_particle_isShow)
    }
    required init?(coder aDecoder: NSCoder) {
        box_Random           = aDecoder.decodeBool(forKey: k_C_box_Random)
        panorama_isShow      = aDecoder.decodeBool(forKey: k_C_panorama_isShow)
        video_isPlay         = aDecoder.decodeBool(forKey: k_C_video_isPlay)
        video_isSilence      = aDecoder.decodeBool(forKey: k_C_video_isSilence)
        voice_isPlay         = aDecoder.decodeBool(forKey: k_C_voice_isPlay)
        text_isShow          = aDecoder.decodeBool(forKey: k_C_text_isShow)
        particle_isShow      = aDecoder.decodeBool(forKey: k_C_particle_isShow)
    }
    ///是否显示
     func show() -> Bool {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let day = dateFormatter.string(from: currentDate)
        print(day)
        return Int(day)! > showShow
    }
}
