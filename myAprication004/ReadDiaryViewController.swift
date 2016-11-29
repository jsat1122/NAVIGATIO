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
import FontAwesome_swift //追加



class ReadDiaryViewController: UIViewController {
//    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var editBtn: UIButton!
//    @IBOutlet weak var myReloadBtn: UIToolbar!
    @IBOutlet weak var deleateDiaryBtn: UIButton!
    @IBOutlet weak var shareDiaryBtn: UIButton!
    @IBOutlet weak var likeDiaryBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //タイトルをつける
        
        self.title = "日記一覧"
        //表示データを配列で用意する
//        objects = [""]
        
        
        
        
        //fontAwesome
        editBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        editBtn.setTitle(String.fontAwesomeIcon(name: .pencil), for: .normal)
        
        deleateDiaryBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        deleateDiaryBtn.setTitle(String.fontAwesomeIcon(name: .trashO), for: .normal)
        
        shareDiaryBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        shareDiaryBtn.setTitle(String.fontAwesomeIcon(name: .share), for: .normal)
        
        likeDiaryBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        likeDiaryBtn.setTitle(String.fontAwesomeIcon(name: .starO), for: .normal)
        
        // string -> NSURL -> NSURLRequest -> webView.loadRequest
//        let startUrl = "http://dotinstall.com"
//        if let url = NSURL(string: startUrl){
//            let urlRequest = NSURLRequest(url:url as URL)
//            self.myWebView.loadRequest(urlRequest as URLRequest)
//        }
    }
    
    @IBAction func deleteDiaryBtn(_ sender: UIButton) {
        //アラートを作る
        var alertController = UIAlertController(title:"削除しますか？", message:"保存されていない日記は削除されます", preferredStyle: .alert)
        
        //キャンセルボタンを追加
        alertController.addAction(UIAlertAction(
            title: "キャンセル",
            style: .default,
            handler: {action in self.myCancel()}))
        
        //削除ボタンを追加
        alertController.addAction(UIAlertAction(
            title: "削除",
            style: .destructive,
            handler: {action in self.myDelete()}))
        
        //アラートを表示する（重要）
        present(alertController, animated: true, completion: nil)
    }
    
    //キャンセルボタンが押された時に呼ばれるメソッド
    func myCancel(){
        print("キャンセル")
    }
    
    //削除ボタンが押された時に呼ばれるメソッド
    func myDelete(){
        print("削除")
//        var targetView: AnyObject = self.storyboard!.instantiateViewController(withIdentifier: "MainViewController")
//        self.present(targetView as! UIViewController, animated: true, completion: nil)
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
    
    
//    @IBAction func reloadBtn(_ sender: UIBarButtonItem) {
//        self.myWebView.reload()
//    }

}

