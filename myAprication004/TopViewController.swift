//
//  TopViewController.swift
//  myAprication004
//
//  Created by Apple on 2016/11/18.
//  Copyright © 2016年 Takahiro Ono. All rights reserved.
//

import UIKit
import FontAwesome_swift //追加

//import SceneKit


class TopViewController: UIViewController {
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var swipeRight: UIButton!

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        //NavigationBarを表示しない(true) *表示させたい最初の画面でfalseに変更すればそこからは現れる
        self.navigationController?.isNavigationBarHidden = true
        
        //topImage.image = UIImage(named: "earth.jpeg")

        // Do any additional setup after loading the view.
        
        //fontAwesome
        swipeRight.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        swipeRight.setTitle(String.fontAwesomeIcon(name: .angleDoubleRight), for: .normal)
        
        // アニメーション用の画像
        let image1 = UIImage(named:"japan.png")!
        
        // UIImageView のインスタンス生成,ダミーでimage1を指定
        topImage.image = image1
        
        
    }
    
    @IBAction func swipeAction(_ sender: UISwipeGestureRecognizer) {
        
////        let mainViewController = MainViewController = segue.destinationViewController as MainViewController
//        mainViewController.myName = self.swipeAction
        // アニメーション用の画像
        let image1 = UIImage(named:"japan.png")!
        let image2 = UIImage(named:"Africa.png")!
        let image3 = UIImage(named:"midleEast.png")!
        let image4 = UIImage(named:"southAmerica.png")!
        let image5 = UIImage(named:"sea.png")!
        
        // UIImage の配列を作る
        var imageListArray :Array<UIImage> = []
        
        // UIImage 各要素を追加、ちょっと冗長的ですが...
        imageListArray.append(image1)
        imageListArray.append(image5)
        imageListArray.append(image4)
        imageListArray.append(image3)
        imageListArray.append(image2)
        
        // view に追加する
        //self.view.addSubview(topImage)
        
        // 画像の配列をアニメーションにセット
        topImage.animationImages = imageListArray
        
        // 1.5秒間隔
        topImage.animationDuration = 1
                // アニメーションを開始
        topImage.startAnimating()
        
        self.perform("afterAnimation", with: nil, afterDelay: topImage.animationDuration)
        
    }
    
    func afterAnimation() {
        topImage.stopAnimating()
        // 3回繰り返し
        //topImage.animationRepeatCount = 3

        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.navigationController?.pushViewController(nextView, animated: true)
        
        //self.push(nextView, animated: true, completion: nil)
    }
    
//    self.performSelector("afterAnimation", withObject: nil, afterDelay: imageView1.animationDuration)
//    func afterAnimation() {
//        imageView1.stopAnimating()
//        imageView1.image = imageArray.last
//    }
    
//    
//    boxObj = "earth.jpeg"
//    //角をめんどりした立方体を作る
//    var boxObj = SCNNode()
//    boxObj.geometry = SCNBox(width:3, height:3, length:3, chamferRadius:0.2)
//    boxObj.position = SCNVector3(x: 0,y: 0,z: 3)
//    
//    //テクスチャを作って貼る
//    let material = SCNMaterial()
//    material.diffuse.contents = UIImage(named:"earth")
//    
//    //立方体を登場させる
//    scene.rootNode.addChild.Node(boxObj)

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
