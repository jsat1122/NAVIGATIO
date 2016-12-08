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
    
    //配列の定義
    var diaryArray :[NSDictionary] = []
    var dairyDic :NSDictionary! = [:]
    
    
    //customCell(ListTableViewCell)にアクセスできるようにした
    var cell = ListTableViewCell()
    
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
        // ナビゲーションバーの右側に編集ボタンを追加.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Status Barの高さを取得.
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        // Viewの高さと幅を取得.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // TableViewの生成( status barの高さ分ずらして表示 ).
        diary = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        
        // Cellの登録.
        diary.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceの設定.
        diary.dataSource = self
        
        // Delegateを設定.
        diary.delegate = self
        
        // 罫線を青色に設定.
        diary.separatorColor = UIColor.blue
        
        // 編集中のセル選択を許可.
        diary.allowsSelectionDuringEditing = true
        
        // TableViewをViewに追加する.
        self.view.addSubview(diary)
        
        
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let query: NSFetchRequest<Diary> = Diary.fetchRequest()
        
        do {
            let fetchResults = try viewContext.fetch(query)
            for result: AnyObject in fetchResults {
                let title: String? = result.value(forKey: "title") as? String
                let date: Date = result.value(forKey: "date") as! Date
                let category: String? = result.value(forKey: "category") as? String
                let diary: String? = result.value(forKey: "diary") as? String
                let image: String? = result.value(forKey: "image") as? String
                
                //[辞書のkey:辞書のvalue(値)]
                dairyDic = ["title":title,"date":date,"category":category,"diary":diary,"image":image]
                //配列の一番最後にdiaryDic
                diaryArray.append(dairyDic)
                
                print("title:\(title)")
                print("date:\(date)")
                print("category:\(category)")
                print("diary:\(diary)")
                print("image:\(image)")
            }
        } catch {
            fatalError("Failed to fetch diary: \(error)")
        }

    }
    
    /*
     Cellが選択された際に呼び出される.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 選択中のセルが何番目か.
        print("Num: \(indexPath.row)")
        
        // 選択中のセルのvalue.
        print("Value: \(diaryArray[indexPath.row])")
        
        // 選択中のセルを編集できるか.
        print("Edeintg: \(tableView.isEditing)")
    }
    
    /*
     編集ボタンが押された際に呼び出される
     */
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // TableViewを編集可能にする
        diary.setEditing(editing, animated: true)
        
        // 編集中のときのみaddButtonをナビゲーションバーの左に表示する
        if editing {
            print("編集中")
            let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ViewController.addCell(sender:)))
            self.navigationItem.setLeftBarButton(addButton, animated: true)
        } else {
            print("通常モード")
            self.navigationItem.setLeftBarButton(nil, animated: true)
        }
    }
    
    /*
     addButtonが押された際呼び出される
     */
    func addCell(sender: AnyObject) {
        print("追加")
        let someObjects: [AnyObject]
//        // セルを設定、型変換
//        let dateText = DateFormatter()
//        dateText.dateFormat = "yyyy/MM/dd"
//        var dateTextdate:Date = dateText.date(from: imageDates[indexPath.row])!
//     
        for movie in someObjects as! [Array<Any>] {
            let movie = object as! Array
        }
        // myItemsに追加.
        movie.add("add Cell")
        
        // myItemsに追加.
        myItems.add("add Cell")
        
//        // セルを設定、型変換
//        let imageNames = DateFormatter()
//        imageNames.dateFormat = "add Cell"
//        var imageNamesDate:Date = imageNames.date(from: imageNames.add("add Cell"))!
//        // myItemsに追加.
//        imageNamesDate.add("add Cell")
        
        // TableViewを再読み込み.
        diary.reloadData()
    }
    
    /*
     Cellを挿入または削除しようとした際に呼び出される
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.delete {
            print("削除")
            
            //        // セルを設定、型変換
            //        let dateText = DateFormatter()
            //        dateText.dateFormat = "yyyy/MM/dd"
            //        var dateTextdate:Date = dateText.date(from: imageDates[indexPath.row])!
            //        
            
            
//
//                    // セルを設定、型変換
//                    let imageNames = DateFormatter()
//                    imageNames.dateFormat = "yyyy/MM/dd"
//                    var imageNamesDates:Date = imageNames.date(from: indexPath.row)!
//                    
//
//            // 指定されたセルのオブジェクトをmyItemsから削除する.
//            imageNames.removeObject(at: imageNamesDates)
            
            // TableViewを再読み込み.
            diary.reloadData()
        }
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
        cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! ListTableViewCell
        
        // セルを設定、型変換
        let dateText = DateFormatter()
        dateText.dateFormat = "yyyy/MM/dd"
        var dateTextdate:Date = dateText.date(from: imageDates[indexPath.row])!
        
        //imageDates.text = formatter.string(from: dateText)
        
        cell.setCell(imageName: imageNames[indexPath.row], titleText: imageTitles[indexPath.row], dateText: dateTextdate, categoryText: imageCategorys[indexPath.row], diaryText: imageDairys[indexPath.row])
        
        return cell
    }
}
