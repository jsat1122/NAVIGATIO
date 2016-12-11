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
    
    @IBOutlet weak var diaryTableView: UITableView!
//    // テーブルを用意
//    var diary: UITableView!
    
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
        
//        // TableViewの生成( status barの高さ分ずらして表示 ).
//        diaryTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
//        
//        // Cellの登録.
//        diaryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
//        
//        // DataSourceの設定.
//        diaryTableView.dataSource = self
//        
//        // Delegateを設定.
//        diaryTableView.delegate = self
//        
//        // 罫線を青色に設定.
//        diaryTableView.separatorColor = UIColor.blue
//        
//        // 編集中のセル選択を許可.
//        diary.allowsSelectionDuringEditing = true
//        
//        // TableViewをViewに追加する.
//        self.view.addSubview(diary)
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
        diaryTableView.setEditing(editing, animated: true)
        
    }
    
    
    /*
     Cellを挿入または削除しようとした際に呼び出される
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.delete {
            print("削除")
            
            // 指定されたセルのオブジェクトをmyItemsから削除する.
            diaryArray.remove(at: indexPath.row)
            print(indexPath.row)
            print(diaryArray)
            
            // TableViewを再読み込み.
            diaryTableView.reloadData()
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
        
        var tmpDic = diaryArray[(indexPath as NSIndexPath).row]
        print(tmpDic["date"] )
        
        let dateText = DateFormatter()
        dateText.dateFormat = "yyyy/MM/dd"
        var dateTextdate:String = dateText.string(from: (tmpDic["date"] as! Date))
        
        
        //imageDates.text = formatter.string(from: dateText)
        cell.myDateLabel.text = dateTextdate
        cell.myTitleLabel.text = tmpDic["title"] as? String
        cell.myCategoryLabel.text = tmpDic["category"] as? String
        cell.myDiaryLabel.text = tmpDic["diary"] as? String
        
        
        
        
        
        
        
        
//        cell.setCell(imageName: imageNames[indexPath.row], titleText: imageTitles[indexPath.row], dateText: dateTextdate, categoryText: imageCategorys[indexPath.row], diaryText: imageDairys[indexPath.row])
        
        return cell
    }
}
