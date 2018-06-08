# HeavenMemoirs - AR相册
ARKit 

线上地址
https://itunes.apple.com/cn/app/weare/id1304227680?mt=8

![image](https://github.com/SherlockQi/HKNote/blob/master/image/WeAre.gif)
# HeavenMemoirs
**技术点**
>AR初始化
在新建项目时可以直接创建 AR 项目, xcode 会创造一个 AR 项目的模板.

也可以创建普通的项目,在需要实现 AR 功能的控制器中实现如下代码进行初始化.
```
      import ARKit
      let sceneView = ARSCNView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.frame = view.bounds
        view.addSubview(sceneView)

        sceneView.delegate = self
        sceneView.showsStatistics = true
      
        // 创建一个场景,系统默认是没有的
        let scene = SCNScene()
        sceneView.scene = scene

          //不允许用户操作摄像机
         sceneView.allowsCameraControl = false
          //抗锯齿
         sceneView.antialiasingMode = .multisampling4X

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
```
>添加节点
```
      //我使用的是 SCNPlane 来充当相框,也可以使用"厚度"很小的 SCNBox
      let photo = SCNPlane(width: 1, height: 1)
      //photo.cornerRadius = 0.01
      let image = UIImage(named: "0")
      //纹路可以使图片,也可以是颜色
      photo.firstMaterial?.diffuse.contents = image
      //photo.firstMaterial?.diffuse.contents = UIColor.red
      let photoNode = SCNNode(geometry: photo)
      //节点的位置
      let vector3 = SCNVector3Make(-1, -1, -1) 
      photoNode.position = vector3
      sceneView.scene.rootNode.addChildNode(photoNode)
```
```
      let text = SCNText(string: "文字", extrusionDepth: 0.1)
      text.font = UIFont.systemFont(ofSize: 0.4)
      let textNode = SCNNode(geometry: text)
      textNode.position = SCNVector3Make(0,0, -1)
      //文字的图片/颜色
      text.firstMaterial?.diffuse.contents = UIImage(named: color)
      sceneView.scene.rootNode.addChildNode(textNode)
```
```
可供选择的几何图形
      SCNText 文字  
      SCNPlane 平面  
      SCNBox 盒子  
      SCNPyramid 锥形  
      SCNSphere 球  
      SCNCylinder 圆柱  
      SCNCone 圆锥  
      SCNTube 圆筒  
      SCNCapsule 胶囊  
      SCNTorus 圆环  
      SCNFloor 地板  
      SCNShape 自定义
```
>全景图实现
```
      想象自己站在一个球的球心处,球的内表面涂着壁画,那么是不是就实现了全景图.
      所以用一个Sphere 节点包裹着相机节点(也就是0位置节点),再设置Sphere节点的内表面纹理,就实现了功能.

      let sphere = SCNSphere(radius: 15)
      let sphereNode = SCNNode(geometry: sphere)
      sphere.firstMaterial?.isDoubleSided = true
      sphere.firstMaterial?.diffuse.contents = image
      sphereNode.position = SCNVector3Zero
      scene.rootNode.addChildNode(sphereNode)
```

>播放视频
```
      let height:CGFloat = CGFloat(width) * videoSize.height/videoSize.width
      let box = SCNBox(width: width, height: height, length: 0.3, chamferRadius: 0)
      boxNode.geometry = box;
      boxNode.geometry?.firstMaterial?.isDoubleSided = true
      boxNode.position = SCNVector3Make(0, 0, -5);
      box.firstMaterial?.diffuse.contents = UIColor.red
      self.scene.rootNode.addChildNode(boxNode);
            
            
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
```
>粒子效果
```
      /*
        particleName = "bokeh.scnp"
        particleName = "rain.scnp"
        particleName = "confetti.scnp"
        **/
      particleSytem = SCNParticleSystem(named: particleName, inDirectory: nil){
      particleNode.addParticleSystem(particleSytem)
      particleNode.position = SCNVector3Make(0, Y, 0)
      self.scene.rootNode.addChildNode(particleNode)
```
>节点点击事件
```
      //给 场景视图sceneView 添加点击事件
      let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle(gesture:)))
      sceneView.addGestureRecognizer(tap)
```
```
  @objc func tapHandle(gesture:UITapGestureRecognizer){
      let results:[SCNHitTestResult] = (self.sceneView?.hitTest(gesture.location(ofTouch: 0, in: self.sceneView), options: nil))!
      guard let firstNode  = results.first else{
            return
      }
        // 这就是点击到的节点 可以对他做一些事情 或者根据这个节点的某些属性执行不同的方法
      let node = firstNode.node.copy() as! SCNNode
      if firstNode.node == self.selectNode {
            ...推远照片...
      }else{
            ...拉近照片...
            selectNode = node
      }
}
```
>节点动画
我的另一篇文章中有详细记录[ARKit-动画](https://www.jianshu.com/p/94a41be9477f)
//拉近(推远)照片
```
      //这只是其中一种方法
      let newPosition  = SCNVector3Make(firstNode.node.worldPosition.x*2, firstNode.node.worldPosition.y*2, firstNode.node.worldPosition.z*2)
      let comeOut = SCNAction.move(to: newPosition, duration: 1.2)
      firstNode.node.runAction(comeOut)
```
>自传/公转

```
      //自转
      let box = SCNBox(width: boxW, height: boxW, length: boxW, chamferRadius: 0)
      let boxNode = SCNNode(geometry: box)
      boxNode.position = vector3
      let emptyNode = SCNNode()
      emptyNode.position = SCNVector3Zero
      emptyNode.rotation = SCNVector4Make(0, 1, 0, Float.pi/Float(L/2) * Float(index))
      emptyNode.addChildNode(boxNode)
      photoRingNode.addChildNode(emptyNode)
      let ringAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: right, z: 0, duration: 2))
      boxNode.runAction(ringAction)
            //公转 把节点加到一个正在自传的节点上就可以了
```
>录屏
录屏是使用ReplayKit完成的
开始录屏
```
      协议      
      RPScreenRecorderDelegate,RPPreviewViewControllerDelegate

      RPScreenRecorder.shared().startRecording(handler: nil)
      RPScreenRecorder.shared().delegate = self
```
录制代理
```
func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        print(error ?? "error")
        if error != nil{
            print("error:", error ?? "")
            DispatchQueue.main.async {
                let string = error?.localizedDescription
                ITTPromptView .showMessage(string, andFrameY: 0)
                print(string ?? "")
                //录制期间失败
                self.showFailReplay()
            }
        }else{
            print("else")
        }
        print("start recording handler")
    }
    //录制失败
    func showFailReplay(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HKExplainViewController")
        self.navigationController?.pushViewController(vc, animated: true)
        self.replayButtonRight.constant = 85;
        for button in self.smailButtons {
            button.alpha = 1
        }
        self.mainButton.alpha = 1
        UIView.animate(withDuration: 2.5) {
            self.stopReplayButton.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
```
结束并弹出预览控制器
```
      RPScreenRecorder.shared().stopRecording { (vc, erroe) in
            vc?.previewControllerDelegate = self
            vc?.title = "We Are"
            self.present(vc!, animated: true, completion: nil)
      }
```
预览控制器的代理
```
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        print(activityTypes)
        //取消
        if activityTypes.count == 0 {
            previewController.dismiss(animated: true, completion: nil)
        }
        //保存
        if activityTypes.contains("com.apple.UIKit.activity.SaveToCameraRoll"){
            ITTPromptView .showMessage("视频已保存在相册", andFrameY: 0)
            previewController.dismiss(animated: true, completion: nil)
            //检测到您刚刚保存了视频 是否想要分享
            let delay = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.outputVideo()
            }
        }
    }
```
