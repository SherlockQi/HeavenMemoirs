//
//  HKSelectImageViewController.swift
//  HeavenMemoirs
//
//  Created by HeiKki on 2017/10/17.
//  Copyright © 2017年 HeiKki. All rights reserved.
//

import UIKit
import Photos

let identifier_Box: String = "HKImageCollectionViewCell_Box"
let identifier_H: String = "HKImageCollectionViewCell_H"
let identifier_V: String = "HKImageCollectionViewCell_V"

class HKSelectImageViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var rowBackViews: [UIView]!
    @IBOutlet weak var collectionView_Box: UICollectionView!
    @IBOutlet weak var collectionView_H: UICollectionView!
    @IBOutlet weak var collectionView_V: UICollectionView!
    @IBOutlet weak var panoramaContantView: UIButton!
    @IBOutlet weak var videoContantView: UIButton!
    @IBOutlet weak var textContrantField: UITextField!
    @IBOutlet weak var musicContantView: UIButton!
    // MARK: 高度约束
    @IBOutlet weak var panoramaView_H: NSLayoutConstraint!
    @IBOutlet weak var videoView_H: NSLayoutConstraint!
    @IBOutlet weak var voiceView_H: NSLayoutConstraint!
    @IBOutlet weak var textView_H: NSLayoutConstraint!
    @IBOutlet weak var particleView_H: NSLayoutConstraint!
    @IBOutlet weak var scrollView_Bottom: NSLayoutConstraint!
    // MARK: Swith
    @IBOutlet weak var boxRandomSwitch: UISwitch!
    @IBOutlet weak var panoramaBackSwitch: UISwitch!
    @IBOutlet weak var videoSwitch: UISwitch!
    @IBOutlet weak var voiceSwitch: UISwitch!
    @IBOutlet weak var textSwitch: UISwitch!
    @IBOutlet weak var particleSwitch: UISwitch!
    var containerCollectionView: UICollectionView?
    // MARK: Button
    var textColorButton: UIButton?
    @IBOutlet weak var silenceButton: UIButton!
    @IBOutlet var textColorButtons: [UIButton]!
    @IBOutlet var particleButtons: [UIButton]!
    ///资源管理
    let rescouceManager = RescouceManager.share
    ///配置管理
    let rescoucceConfiguration = RescouceConfiguration.share
    var box_Delete: Bool = false {
        didSet {
            for cell in collectionView_Box.visibleCells {
                cellShake(cell: cell, shake: box_Delete)
            }
        }
    }
    var H_Delete: Bool = false {
        didSet {
            for cell in collectionView_H.visibleCells {
                cellShake(cell: cell, shake: H_Delete)
            }
        }
    }
    var V_Delete: Bool = false {
        didSet {
            for cell in collectionView_V.visibleCells {
                cellShake(cell: cell, shake: V_Delete)
            }
        }
    }
    @IBAction func completeButtonDidClick(_ sender: UIButton) {
        rescouceManager.text = textContrantField.text
        setRescoucceConfiguration()
        //判断三个数组图片
        if rescouceManager.verticalImages.count == 0 {
            ITTPromptView.showMessage("请至少选择一个竖向图片", andFrameY: 0)
            return
        }
        if rescouceManager.horizontalImages.count == 0 {
            ITTPromptView.showMessage("请至少选择一个横向图片", andFrameY: 0)
            return
        }
        if rescouceManager.boxImages.count == 0 {
            ITTPromptView.showMessage("请至少选择一个方形图片", andFrameY: 0)
            return
        }
        DispatchQueue.global().async {
            var path=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            path+="/RescouceManager"
            NSKeyedArchiver.archiveRootObject(self.rescouceManager, toFile: path)
            var c_path=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            c_path+="/RescouceConfiguration"
            print("路径："+c_path)
            NSKeyedArchiver.archiveRootObject(self.rescoucceConfiguration, toFile: c_path)
        }
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        addObserver()
        updateUI()
        addShadow()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        panoramaContantView.setBackgroundImage(rescouceManager.panoramaImage, for: .normal)
         musicContantView.setTitle(rescouceManager.musicName, for: .normal)
        if  musicContantView.currentTitle == "" || musicContantView.currentTitle == nil {
            self.musicContantView.setTitle("选择", for: .normal)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func registerCell() {
        collectionView_Box.register(HKImageCollectionViewCell.self, forCellWithReuseIdentifier: identifier_Box)
        collectionView_H.register(HKImageCollectionViewCell.self, forCellWithReuseIdentifier: identifier_H)
        collectionView_V.register(HKImageCollectionViewCell.self, forCellWithReuseIdentifier: identifier_V)
    }
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(deleteImage(notify:)), name: NSNotification.Name(rawValue: "Notification_NAME_ImageDetele"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func addShadow() {
        for view in rowBackViews {
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.shadowOpacity = 0.4
            view.layer.shadowRadius = 4.0
            view.layer.shadowOffset = CGSize(width: 4, height: 4)
            view.layer.cornerRadius = 4.0
        }
    }
    func updateUI() {
        setSwitch()
        updateText()
        self.videoContantView.setBackgroundImage(rescouceManager.videoImage, for: .normal)
        let button = particleButtons[rescouceManager.particleType]
            button.isSelected = true
    }
    func updateText() {
        if let text = rescouceManager.text {
            textContrantField.text = text
            for button in textColorButtons where button.currentTitle == rescouceManager.textColor {
                    button.isSelected = true
                    textColorButton = button
            }
        } else {
            textColorButtons.first?.isSelected = true
            textColorButton = textColorButtons.first
        }
    }
    func setRescoucceConfiguration() {
        rescoucceConfiguration.video_isSilence      = silenceButton.isSelected
        rescoucceConfiguration.box_Random           = boxRandomSwitch.isOn
        rescoucceConfiguration.panorama_isShow      = panoramaBackSwitch.isOn
        rescoucceConfiguration.video_isPlay         = videoSwitch.isOn
        rescoucceConfiguration.voice_isPlay         = voiceSwitch.isOn
        rescoucceConfiguration.text_isShow          = textSwitch.isOn
        rescoucceConfiguration.particle_isShow      = particleSwitch.isOn
    }
    func setSwitch() {
        silenceButton.isSelected = rescoucceConfiguration.video_isSilence
        boxRandomSwitch.setOn(rescoucceConfiguration.box_Random, animated: false)
        panoramaBackSwitch.setOn(rescoucceConfiguration.panorama_isShow, animated: false)
        videoSwitch.setOn(rescoucceConfiguration.video_isPlay, animated: false)
        voiceSwitch.setOn(rescoucceConfiguration.voice_isPlay, animated: false)
        textSwitch.setOn(rescoucceConfiguration.text_isShow, animated: false)
        particleSwitch.setOn(rescoucceConfiguration.particle_isShow, animated: false)
        panoramaView_H.constant     = panoramaBackSwitch.isOn ? 180 : 46
        videoView_H.constant        = videoSwitch.isOn ? 180 : 46
        voiceView_H.constant        = voiceSwitch.isOn ? 180 : 46
        textView_H.constant         = textSwitch.isOn ? 200 : 46
        particleView_H.constant      = particleSwitch.isOn ? 100 : 46
    }
    func cellShake(cell: UICollectionViewCell, shake: Bool) {
        let newCell = cell as! HKImageCollectionViewCell
        newCell.cellShake(shake: shake)
    }
    func cancelDelete() {
        box_Delete = false
        H_Delete   = false
        V_Delete   = false
    }
}
//ADD & DELETE
extension HKSelectImageViewController {
    @IBAction func boxAddButtonDidClick(_ sender: UIButton) {
        containerCollectionView = collectionView_Box
        present(imagePicVc(maxImagesCount: 1), animated: true) {}
        cancelDelete()
    }
    @IBAction func addButtonDidClick_H(_ sender: UIButton) {
        containerCollectionView = collectionView_H
        present(imagePicVc(maxImagesCount: 50), animated: true) {}
        cancelDelete()
    }
    @IBAction func addButtonDidClick_V(_ sender: UIButton) {
        containerCollectionView = collectionView_V
        present(imagePicVc(maxImagesCount: 50), animated: true) {}
        cancelDelete()
    }
    func imagePicVc(maxImagesCount: Int) -> TZImagePickerController {
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: maxImagesCount, delegate: self)
        imagePickerVc?.cropRect = CGRect(x: 10, y: (kScreenHeight - kScreenWidth)/2, width: kScreenWidth-20, height: kScreenWidth-20)
        imagePickerVc?.allowCrop = true
        imagePickerVc?.showSelectBtn = false
        imagePickerVc?.allowPickingOriginalPhoto = false
        imagePickerVc?.allowPickingVideo = false
        imagePickerVc?.allowTakePicture = false
        return imagePickerVc!
    }
    @IBAction func boxDeleteButtonDidClick(_ sender: UIButton) {
        containerCollectionView = collectionView_Box
        box_Delete = !box_Delete
    }
    @IBAction func deletaButtonDidClick_H(_ sender: UIButton) {
        containerCollectionView = collectionView_H
        H_Delete = !H_Delete
    }
    @IBAction func deleteButtonDidClick_V(_ sender: UIButton) {
        containerCollectionView = collectionView_V
        V_Delete = !V_Delete
    }
    @objc func deleteImage(notify: Notification) {
        let newCell = notify.object as! HKImageCollectionViewCell
        switch newCell.reuseIdentifier! {
        case identifier_Box:
            if let indexPath = collectionView_Box.indexPath(for: newCell) {
                if indexPath.row <= rescouceManager.boxImages.count {
                    rescouceManager.boxImages.remove(at: indexPath.row)
                    collectionView_Box.deleteItems(at: [indexPath])
                }
            }
        case identifier_H:
            if let indexPath = collectionView_H.indexPath(for: newCell) {
                if indexPath.row <= rescouceManager.horizontalImages.count {
                    rescouceManager.horizontalImages.remove(at: indexPath.row)
                    collectionView_H.deleteItems(at: [indexPath])
                }
            }
        case identifier_V:
            if let indexPath = collectionView_V.indexPath(for: newCell) {
                if indexPath.row <= rescouceManager.verticalImages.count {
                    rescouceManager.verticalImages.remove(at: indexPath.row)
                    collectionView_V.deleteItems(at: [indexPath])
                }
            }
        default: break
        }
    }
    // MARK: 选择视频
    @IBAction func videoButtonDidClick(_ sender: UIButton) {
        let imagePicker = imagePicVc(maxImagesCount: 1)
        imagePicker.allowPickingVideo = true
        present(imagePicker, animated: true, completion: nil)
    }
    // MARK: 静音
    @IBAction func videoSilenceButtonDidClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        rescoucceConfiguration.video_isSilence = sender.isSelected
    }
    // MARK: 选择全景
    @IBAction func selectPanoramaButtonDidClick(_ sender: UIButton) {
        if rescoucceConfiguration.show() {
            let musicVc = HKPanoramaSelectViewController.vc()
            self.navigationController?.pushViewController(musicVc, animated: true)
        } else {
            ITTPromptView.showMessage("功能开发中,敬请期待", andFrameY: 0)
        }
    }
    // MARK: 选择音频
    @IBAction func selectMusicButtonDidClick(_ sender: UIButton) {

        if rescoucceConfiguration.show() {
            let musicVc = HKMusicSelectTableViewController.vc()
            self.navigationController?.pushViewController(musicVc, animated: true)
        } else {
            ITTPromptView.showMessage("功能开发中,敬请期待", andFrameY: 0)
        }
    }
    // MARK: 选择粒子系统
    @IBAction func particleButtonDidClick(_ sender: UIButton) {
        for button in particleButtons {
            button.isSelected = false
        }
        sender.isSelected = true
        let teg = sender.tag - 10086
        rescouceManager.particleType = teg
    }
    // MARK: 选择颜色
    @IBAction func textColorButtonDidClick(_ sender: UIButton) {
        textColorButton?.isSelected = false
        textColorButton = sender
        textColorButton?.isSelected = true
        rescouceManager.textColor = sender.currentTitle!
    }
    // MARK: 评分
    @IBAction func supportButtonDidClick(_ sender: UIButton) {
              HKTools().toAppStore(vc: self)
    }
}
// MARK: Swith
extension HKSelectImageViewController {
    @IBAction func boxRandomSwithValueChange(_ sender: UISwitch) {
        rescoucceConfiguration.box_Random = sender.isOn
        change_H()
    }
    @IBAction func panoramaValueChange(_ sender: UISwitch) {
        panoramaView_H.constant = sender.isOn ? 180 : 46
        rescoucceConfiguration.panorama_isShow = sender.isOn
        change_H()
    }
    @IBAction func videoSwitchValueChanged(_ sender: UISwitch) {
        videoView_H.constant = sender.isOn ? 180 : 46
        rescoucceConfiguration.video_isPlay = sender.isOn
        change_H()
    }
    @IBAction func voiceSwitchValueChanged(_ sender: UISwitch) {
        voiceView_H.constant = sender.isOn ? 180 : 46
        rescoucceConfiguration.voice_isPlay = sender.isOn
        change_H()
    }
    @IBAction func textSwitchValueChanged(_ sender: UISwitch) {
        textView_H.constant = sender.isOn ? 200 : 46
        rescoucceConfiguration.text_isShow = sender.isOn
        change_H()
    }
    @IBAction func particleSwitchValueChanged(_ sender: UISwitch) {
        particleView_H.constant = sender.isOn ? 100 : 46
        rescoucceConfiguration.particle_isShow = sender.isOn
        change_H()
    }
    func change_H() {
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}
// MARK: TZImagePickerControllerDelegate
extension HKSelectImageViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        if self.containerCollectionView == collectionView_Box {
            for image in photos {
                rescouceManager.addBoxImage(image: image)
            }
        } else if self.containerCollectionView == collectionView_H {
            for image in photos {
                rescouceManager.addHorizontalImage(image: image)
            }
        } else if self.containerCollectionView == collectionView_V {
            for image in photos {
                rescouceManager.addVerticalImage(image: image)
            }
        }
        containerCollectionView?.reloadData()
        containerCollectionView = nil
    }
    //选择了视频文件
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: Any!) {
        rescouceManager.videoImage = coverImage
        self.videoContantView.setBackgroundImage(coverImage, for: .normal)
        let manager = PHImageManager.default()
        let options = PHVideoRequestOptions()
        options.version = .original
        options.deliveryMode = .automatic
        options.isNetworkAccessAllowed = true
        manager.requestPlayerItem(forVideo: asset as! PHAsset, options: options) { (item, _) in
            let videoAsset = item?.asset as! AVURLAsset
            self.rescouceManager.videoURL = videoAsset.url
            print(videoAsset.url)
        }
    }
}

// MARK: UICollectionViewDelegate & UICollectionViewDataSource
extension HKSelectImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var num = 0
        if collectionView == collectionView_Box {
            num = rescouceManager.boxImages.count
        } else if collectionView == collectionView_H {
            num = rescouceManager.horizontalImages.count
        } else if collectionView == collectionView_V {
            num = rescouceManager.verticalImages.count
        }
        return num
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier: String = ""
        var image: UIImage?
        if collectionView == collectionView_Box {
            identifier = identifier_Box
            image = rescouceManager.boxImages[indexPath.row]
        } else if collectionView == collectionView_H {
            identifier = identifier_H
            image = rescouceManager.horizontalImages[indexPath.row]
        } else if collectionView == collectionView_V {
            identifier = identifier_V
            image = rescouceManager.verticalImages[indexPath.row]
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! HKImageCollectionViewCell
        cell.imageView.image = image
        if collectionView == collectionView_Box {
            cellShake(cell: cell, shake: box_Delete)
        } else if collectionView == collectionView_H {
            cellShake(cell: cell, shake: H_Delete)
        } else if collectionView == collectionView_V {
            cellShake(cell: cell, shake: V_Delete)
        }
        return cell
    }
}
// MARK: KeyBoard
extension HKSelectImageViewController {
    @objc func keyBoardWillShow(_ notification: Notification) {
        self.scrollView_Bottom.constant = 160
        let rect = CGRect(x: 0, y: scrollView.contentSize.height - 600, width: scrollView.contentSize.width, height: 667)
        self.scrollView.scrollRectToVisible(rect, animated: true)
    }
    @objc func keyBoardWillHide(_ notification: Notification) {
        self.scrollView_Bottom.constant = 60
    }
}
