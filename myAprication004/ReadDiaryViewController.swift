//
//  SecondViewController.swift
//  myAprication004
//
//  Created by Apple on 2016/11/18.
//  Copyright © 2016年 Takahiro Ono. All rights reserved.
//

import UIKit
import Social //追加
import Accounts //追加


class ReadDiaryViewController: UIViewController {
    @IBOutlet weak var myWebView: UIWebView!

    @IBOutlet weak var myReloadBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //タイトルをつける
        
        self.title = "日記一覧"
        //表示データを配列で用意する
//        objects = [""]
        
        // string -> NSURL -> NSURLRequest -> webView.loadRequest
        let startUrl = "http://dotinstall.com"
        if let url = NSURL(string: startUrl){
            let urlRequest = NSURLRequest(url:url as URL)
            self.myWebView.loadRequest(urlRequest as URLRequest)
        }
    }
    @IBAction func reloadBtn(_ sender: UIBarButtonItem) {
            self.myWebView.reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tapBtnTwiter(_ sender: UIButton) {
        //共有する項目の設定
        //テキスト
        let shareText = "Apple - Apple Watch"
        
        //URL
        let shareWebsite = "https://www.apple.com/jp/watch/"
        
        //画像(sample.pngがプロジェクト上に存在していることが前提)
        let shareImage = UIImage(named: "sample.png")
        
        
        //共有する項目を配列に指定
        //let activityItems = [shareText,shareWebsite]
        let activityItems = [shareText,shareWebsite,shareImage] as [Any]
        
        //ActivityViewの作成、初期化
        let activityVC = UIActivityViewController(activityItems:activityItems, applicationActivities:nil)
        
        //ActivityViewの表示
        self.present(activityVC, animated:true, completion: nil)
    }
//    @IBAction func tapBtnFacebook(_ sender: UIButton) {
//        var facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//        facebookVC?.setInitialText("投稿するよ")
//        present(facebookVC!, animated: true, completion: nil)
//    }


}

