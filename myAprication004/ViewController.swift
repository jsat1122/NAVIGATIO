//
//  ViewController.swift
//  myAprication004
//
//  Created by Apple on 2016/11/29.
//  Copyright © 2016年 Takahiro Ono. All rights reserved.
//
import UIKit
import CoreData //追加
import Photos //追加
import MobileCoreServices //追加
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var deleteDiary: Date! = nil //空のメンバ変数
    
    //配列の定義
    var diaryArray :[NSDictionary] = []
    var dairyDic :NSDictionary! = [:]
    
    var lunchMenu:NSArray = [[:]]
    
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
                let created_at: Date = result.value(forKey: "created_at") as! Date
                
                //[辞書のkey:辞書のvalue(値)]
                dairyDic = ["title":title,"date":date,"category":category,"diary":diary,"image":image,"created_at":created_at]
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
        
        //日付の最新順に並べる
        let sortDescription = NSSortDescriptor(key: "date", ascending: false)
        let sortDescAry = [sortDescription]
        diaryArray = ((diaryArray as NSArray).sortedArray(using: sortDescAry) as NSArray) as! [NSDictionary]
        
        
        print(diaryArray)
        
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
     Cellを削除しようとした際に呼び出される
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.delete {
            print("削除")
            
            // 指定されたセルのオブジェクトをmyItemsから削除する.
            
            diaryArray.remove(at: indexPath.row)
            print(indexPath.row)
            print(diaryArray)
        }
            
            
            // CoreDataに指令を出すviewContextを生成
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let viewContext = appDelegate.persistentContainer.viewContext
            // 読み込むエンティティを指定
//            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
            
            let diary = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext)
            var selectedDate = deleteDiary
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyy/MM/dd/hh/mm/ss"
            var tmpDateStr = formatter.string(from: date)
            var changeDate = formatter.date(from: tmpDateStr)
            let request: NSFetchRequest<Diary> = Diary.fetchRequest()
            let strSavedDate: String = formatter.string(from: selectedDate!)
            var savedDate :Date = formatter.date(from: strSavedDate)!
            do {
                let namePredicte = NSPredicate(format: "created_at = %@", savedDate as CVarArg)
                request.predicate = namePredicte
                //1件削除
                
                do {
                    let fetchResults = try viewContext.fetch(request)
                    for result: AnyObject in fetchResults {
                        let record = result as! NSManagedObject
                        viewContext.delete(record)
                    }
                    try viewContext.save()
                } catch {
                }
            }
            
           
//            // 更新するデータを指定する。この場合ショップ名が市場のレコード。
//            let title: String? = results.value(format: "title") as? String
//            let date: Date = results.value(format: "date") as! Date
//            let category: String? = results.value(format: "category") as? String
//            let diary: String? = results.value(format: "diary") as? String
//            let image: String? = results.value(format: "image") as? String
            
//            let predict = NSPredicate(format: "title", "date", "category", "diary", "image")
//            fetchReq.predicate = predict
//            // データを格納する空の配列を用意
//            var result = []
//            // 読み込み実行
//            do {
//                result = try viewContext.fetch(fetchReq)
//            }catch{
//                
//            }
//            // Diaryインスタンスを生成
//            let diary = result[0] as! Diary
//            // 削除
//            viewContext.delete(diary)
//            // 保存
//            do{
//                try viewContext.save()
//            }catch{
//                
//            }
            
            
            // TableViewを再読み込み.
            diaryTableView.reloadData()
        
    }
    
//    // (6) 移動時の処理
//    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//        
//        // データの順番を整える
//        let targetTitle = diaryArray[sourceIndexPath.row]
//        if let index = diaryArray.index(of: targetTitle) {
//            diaryArray.remove(at: index)
//            diaryArray.insert(targetTitle, at: destinationIndexPath.row)
//            print(diaryArray)
//        }
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//        print(diaryArray[indexPath.row])
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    //背景と同じ色にして見えなくする
//    @IBOutlet weak var labelDiary: UILabel!
    
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //diaryArrayの数の分だけ表示する
        return diaryArray.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得
        cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! ListTableViewCell
        
        var tmpDic = diaryArray[(indexPath as NSIndexPath).row]
        print(tmpDic["date"] )
        
        deleteDiary = tmpDic["created_at"]as! Date
        
        let dateText = DateFormatter()
        dateText.dateFormat = "yyyy/MM/dd"
        var dateTextdate:String = dateText.string(from: (tmpDic["date"] as! Date))
        
        
        //imageDates.text = formatter.string(from: dateText)
        cell.myDateLabel.text = dateTextdate
        cell.myTitleLabel.text = tmpDic["title"] as? String
        cell.myCategoryLabel.text = tmpDic["category"] as? String
        cell.myDiaryLabel.text = tmpDic["diary"] as? String
        
        //UserDefaultから取り出す
        // ユーザーデフォルトを用意する
        let myDefault = UserDefaults.standard
        
        // データを取り出す
        let strURL = myDefault.string(forKey: "selectedPhotoURL")
        
        if strURL != nil{
            
            let url = URL(string: strURL as String!)
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            // 画像の設定.
            let i:UIImage = UIImage(named:"No image.png")!
            if i == nil{
                let i = "No image.png"
            }else{

            manager.requestImage(for: asset,targetSize: CGSize(width: 5, height: 500),contentMode: .aspectFill,options: nil) { (image, info) -> Void in
                self.cell.myImageView.image = image
            }
            }
        }
        
//        cell.setCell(imageName: imageNames[indexPath.row], titleText: imageTitles[indexPath.row], dateText: dateTextdate, categoryText: imageCategorys[indexPath.row], diaryText: imageDairys[indexPath.row])
        
        return cell
    }
}
