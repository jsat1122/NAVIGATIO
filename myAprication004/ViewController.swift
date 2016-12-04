//
//  ViewController.swift
//  myAprication004
//
//  Created by Apple on 2016/11/29.
//  Copyright © 2016年 Takahiro Ono. All rights reserved.
//
import UIKit
import CoreData //追加

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // ナビバーの右上ボタンを用意
    var addBtn: UIBarButtonItem!
    
    // テーブルを用意
    var diary: UITableView!
    
    /// 画像のファイル名
    let imageNames = ["cat1.jpg", "cat2.jpg", "dog1.jpg", "dog2.jpg"]
    
    /// 画像のタイトル
    let imageTitles = ["ネコ1", "ネコ2", "イヌ1", "イヌ2"]
    
    /// 画像の日付
    let imageDates = ["2016/9/24", "2016/9/25", "2016/9/26", "2016/9/27"]
    
    /// 画像のカテゴリー
    let imageCategorys = ["卒業旅行", "新婚旅行", "世界一周", "記念旅行"]
    
    /// 画像の説明
    let imageDairys = [
        "ボックスから顔だけだして下を見ているオス猫",
        "寝ころびながらじゃれる猫",
        "散歩中のポメラニアン",
        "お散歩中のワンちゃん"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as!
        
        ListTableViewCell
        
        // セルを設定
        cell.setCell(imageName: imageNames[indexPath.row], titleText: imageTitles[indexPath.row], dateText: imageDates[indexPath.Int], categoryText: imageCategorys[indexPath.row], diaryText: imageDairys[indexPath.row])
        
        return (cell)
    }
}
