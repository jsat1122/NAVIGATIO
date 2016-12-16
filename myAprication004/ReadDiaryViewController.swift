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
import CoreData //追加


class ReadDiaryViewController: UIViewController {
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleateDiaryBtn: UIButton!
    @IBOutlet weak var shareDiaryBtn: UIButton!
    @IBOutlet weak var likeDiaryBtn: UIButton!
    @IBOutlet weak var myTitleLabel: UILabel!
    @IBOutlet weak var myDateLabel: UILabel!
    @IBOutlet weak var myCategoryLabel: UILabel!
    @IBOutlet weak var myDiaryLabel: UITextView!
    @IBOutlet weak var myImageLabel: UIImageView!
    
    var editDiary: Date! = nil //空のメンバ変数
    var createdDiary: Date! = nil //空のメンバ変数
    
    var dairyDic :NSDictionary! = [:] 
    
//    var myName: String = ""
    var diaryArray :[NSDictionary] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //タイトルをつける
        self.title = "日記詳細"
//        //表示データを配列で用意する
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
        
        if createdDiary != nil {
        // CoreDataに指令を出すviewContextを生成
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext

        // 読み込むエンティティを指定
        //            let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
        
        let diary = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext)
//        var selectedDate = createdDiary
//        
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone.current
//        formatter.dateFormat = "yyyy/MM/dd/hh/mm/ss"
//        var tmpDateStr = formatter.string(from: date)
//        var changeDate = formatter.date(from: tmpDateStr)
        let request: NSFetchRequest<Diary> = Diary.fetchRequest()
//        let strSavedDate: String = formatter.string(from: selectedDate!)
//        var savedDate :Date = formatter.date(from: strSavedDate)!
        do {
            let namePredicte = NSPredicate(format: "created_at = %@", createdDiary as CVarArg)
            request.predicate = namePredicte
            //1件削除
            
            do {
                let fetchResults = try viewContext.fetch(request)
                for result: AnyObject in fetchResults {
                    let record = result as! NSManagedObject
                    myTitleLabel.text = record.value(forKey: "title") as! String?
                    myCategoryLabel.text = record.value(forKey: "category") as! String?
                    myDiaryLabel.text = record.value(forKey: "diary") as! String?
                    myImageLabel.image = record.value(forKey: "image") as! UIImage?
                    
                    let dateText = DateFormatter()
                    dateText.dateFormat = "yyyy/MM/dd"
                    var dateTextdate:String = dateText.string(from: (record.value(forKey: "date") as! Date?)!)
                    myDateLabel.text = dateTextdate
                    
                    
                    
                    
                    print(title)
                }
                try viewContext.save()
            } catch {
            }
        }
        }
        
    }
    
    @IBAction func deleteDiaryBtn(_ sender: UIButton) {
        //アラートを作る
        let alertController = UIAlertController(title:"削除しますか？", message:"", preferredStyle: .alert)
        
        //キャンセルボタンを追加
        alertController.addAction(UIAlertAction(
            title: "いいえ",
            style: .default,
            handler: {action in self.myCancel()}))
        
        //削除ボタンを追加
        alertController.addAction(UIAlertAction(
            title: "はい",
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
        navigationController?.viewControllers.removeLast() //views to pop
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
        
//        //画像(※japan.pngがプロジェクト上に存在していることが前提)
//        let shareImage = UIImage(named: "japan.png")
        
        //共有する項目を配列に指定
        let activityItems = [shareText,shareWebsite]
//        let activityItems = [shareText,shareWebsite,shareImage!] as [Any]
        
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

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showResult"{
//            let createDiaryViewController:CreateDiaryViewController = segue.destination as! CreateDiaryViewController
//            createDiaryViewController.myName = self.label.text!
//            self.textField.resignFirstResponder()
//        }
//        
//    }
    
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
//        createdDiary = tmpDic["created_at"]as! Date
//        
//        let storyboard: UIStoryboard = self.storyboard!
//        let nextView = storyboard.instantiateViewController(withIdentifier: "ReadDiaryViewController") as! ReadDiaryViewController
//        nextView.createdDiary = createdDiary
//        self.navigationController?.pushViewController(nextView, animated: true)
        
        // CoreDataに指令を出すviewContextを生成
        //AppDelegateをコードで読み込む
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //Entityの操作を制御するviewContextをappDelegateから作成
        let viewContext = appDelegate.persistentContainer.viewContext
        // 読み込むエンティティを指定
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
        
        let diary = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext)
        var selectedDate = editDiary
        
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
        
    }
}

