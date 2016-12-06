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
        
        // セルを設定
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
        
        //myDateLabel.text = formatter.string(from: dateText)
        //dateTxt.text = formatter.string(from: sender.date)
        
//        var stringNumber:String = "1234"
//        var numberFromString = stringNumber.toInt()
        
//        var stringImageDates:String = "yyyy/MM/dd"
//        var imageDates = stringImageDates.toInt!()
        
//        let x : Int = 123
//        var str = String(x)
        
//        var stringNumb: String = "1357"
//        var someNumb: Int = Int(stringNumb)
//        var someNumbAlt: Int = myString.integerValue
        
//        var dateText: String = "yyyy/MM/dd"
//        var imageDates: Date = Date(dateText)!
//        var someNumbAlt: Date = myString.integerValue

        let dateText = DateFormatter()
        dateText.dateFormat = "yyyy/MM/dd"
        var dateTextdate:Date = dateText.date(from: imageDates[indexPath.row])!
        
        //imageDates.text = formatter.string(from: dateText)
        
        cell.setCell(imageName: imageNames[indexPath.row], titleText: imageTitles[indexPath.row], dateText: dateTextdate, categoryText: imageCategorys[indexPath.row], diaryText: imageDairys[indexPath.row])
        
        return cell
    }
}
