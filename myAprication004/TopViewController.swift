//
//  TopViewController.swift
//  myAprication004
//
//  Created by Apple on 2016/11/18.
//  Copyright © 2016年 Takahiro Ono. All rights reserved.
//

import UIKit
//import SceneKit

class TopViewController: UIViewController {
    @IBOutlet weak var topImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        topImage.image = UIImage(named: "earth.jpeg")

        // Do any additional setup after loading the view.
    }
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
