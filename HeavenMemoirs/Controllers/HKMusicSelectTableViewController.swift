//
//  HKMusicSelectTableViewController.swift
//  HeavenMemoirs
//
//  Created by HeiKki on 2017/10/22.
//  Copyright © 2017年 HeiKki. All rights reserved.
//

import UIKit
import AVFoundation

class HKMusicSelectTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    var musicName:String?
    var musicNames:[String] = ["红昭愿","蓝色降落伞","至此流年各天涯","花 が とぶ 飛ぶ","I Remember","Beautiful In White","岁月神偷","么么","陪你过冬天"]
    
    lazy var musicPlayer: AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    
  class  func vc() -> HKMusicSelectTableViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HKMusicSelectTableViewController")
    return vc as! HKMusicSelectTableViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.tableFooterView = UIView()
    }
    @IBAction func backButtonDidClick(_ sender: UIButton) {
    let manager = RescouceManager.share
        manager.musicName = musicName
        musicPlayer.pause()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicNames.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HKMusicTableViewCell", for: indexPath) as! HKMusicTableViewCell
        cell.musicNameLabel?.text = musicNames[indexPath.row]
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //播放音乐
        if let resourceUrl = Bundle.main.url(forResource: musicNames[indexPath.row], withExtension:"aac") {
            print(resourceUrl.description)
            musicName = musicNames[indexPath.row]
            if FileManager.default.fileExists(atPath: resourceUrl.path) {
                    let item = AVPlayerItem(url: resourceUrl)
                    musicPlayer.replaceCurrentItem(with: item)
                    musicPlayer.play()
            }
        }
    }
}
