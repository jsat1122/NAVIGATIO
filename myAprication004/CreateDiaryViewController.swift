//
//  FirstViewController.swift
//  myAprication004
//
//  Created by Apple on 2016/11/18.
//  Copyright © 2016年 Takahiro Ono. All rights reserved.
//

import UIKit
import CoreData //追加
import FontAwesome_swift //追加
import MobileCoreServices //追加
import Photos //追加
import Foundation //追加

class CreateDiaryViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UITextFieldDelegate{
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var nyCreateBtn: UIButton!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var categoryTxt: UITextField!
    @IBOutlet weak var diaryTxt: UITextView!
    @IBOutlet weak var ImagView: UIImageView!
    
    var strURL: String = ""
    let datepicker: UIDatePicker = UIDatePicker()
    var selectedDate: NSDate = NSDate()
    //下から出てくるviewの設定
    var subView = UIView(frame: CGRect(x:0, y:0, width:100, height: 100))
    let myBoundSize: CGSize = UIScreen.main.bounds.size
    private var closeButton: UIButton!
    private var nowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //入力のヒントになる、プレースホルダーを設定
        titleTxt.placeholder = "タイトルを入力してください"
        dateTxt.placeholder = "日付を入力してください"
        categoryTxt.placeholder = "カテゴリーを入力してください"
//        diaryTxt.placeholder = "日記を入力してください"
//        diaryTxt.placeHolderColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.5)

        
        
        //fontAwesome
        nyCreateBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        nyCreateBtn.setTitle(String.fontAwesomeIcon(name: .floppyO), for: .normal)
        
        deleteBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        deleteBtn.setTitle(String.fontAwesomeIcon(name: .trashO), for: .normal)
        
//        closeButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 15)
//        closeButton.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
        
        
        //viewを見えない位置に追加
        self.subView = UIView(frame: CGRect(x: 0, y: myBoundSize.height, width: myBoundSize.width, height: 220))
        self.subView.backgroundColor = UIColor.clear
        dateTxt.inputView = subView
        
        //subviewの中にボタンを作成する
        //close
        closeButton = UIButton()
        closeButton.frame = CGRect(x: myBoundSize.width - 45, y: 0, width: 45, height: 30)
        closeButton.setTitle("close", for: .normal)
        closeButton.setTitleColor(UIColor.blue, for: .normal)
        closeButton.addTarget(self, action: #selector(self.onClickButton(sender:)), for: .touchUpInside)
        self.subView.addSubview(closeButton)

        //本日
        nowButton = UIButton()
        nowButton.frame = CGRect(x: myBoundSize.width - 230, y: 0, width: 45, height: 30)
        nowButton.setTitle("本日", for: .normal)
        nowButton.setTitleColor(UIColor.black, for: .normal)
        nowButton.addTarget(self, action: #selector(self.onNowButton(sender:)), for: .touchUpInside)
        self.subView.addSubview(nowButton)

        //datepickerの設定
        datepicker.frame = CGRect(x: 0, y: 30, width: myBoundSize.width, height: 190)
        datepicker.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        datepicker.datePickerMode = UIDatePickerMode.date
        datepicker.addTarget(self, action: #selector(self.onDidChangeDate(sender:)), for: .valueChanged)
        // subviewににDatePickerを表示する
        self.subView.addSubview(datepicker)
        dateTxt.delegate = self
        
//        //AccessoryView *今回は使わない
//        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
//        customView.backgroundColor = UIColor.red
//        dateTxt.inputAccessoryView = customView
//        self.dateTxt.text = "現在時刻"
    }
    
    

    
    @IBAction func deleteAction(_ sender: UIButton) {
        //アラートを作る
        let alertController = UIAlertController(title:"削除しますか？", message:"保存されていない日記は削除されます", preferredStyle: .alert)
        
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
        
//        var viewControllers = navigationController?.viewControllers
//        viewControllers?.removeLast(2) //views to pop
//        navigationController?.setViewControllers(viewControllers!, animated: true)
        
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
//        // 遷移するViewを定義する.このas!はswift1.2では as?だったかと。
//        let secondViewController: MainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
//        // アニメーションを設定する.
//        //secondViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
//        // 値渡ししたい時 hoge -> piyo
//        //secondViewController.piyo = self.hoge
//        // Viewの移動する.
//        self.present(secondViewController, animated: true, completion: nil)
//        var targetView: AnyObject = self.storyboard!.instantiateViewController(withIdentifier: "MainViewController")
//        self.present(targetView as! UIViewController, animated: true, completion: nil)
        navigationController?.viewControllers.removeLast() //views to pop
//                navigationController?.setViewControllers(MainViewController!, animated: true)

    }
    
    @IBAction func diaryCreate(_ sender: UIButton) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let diary = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext) //全ての日記を取得
        let newRecord = NSManagedObject(entity: diary!, insertInto: viewContext)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        newRecord.setValue("", forKey: "title") //値を代入
        newRecord.setValue("dateFormatter", forKey: "date")//値を代入
        newRecord.setValue("", forKey: "category")//値を代入
        newRecord.setValue("", forKey: "diary")//値を代入
        newRecord.setValue("", forKey: "image")//値を代入
        
        do {
            try viewContext.save()
        } catch {
        }
        navigationController?.viewControllers.removeLast() //views to pop
        
    }
    override func viewWillAppear(_ animated: Bool) {
        titleTxt.text = ""
        dateTxt.text = ""
        
//        // 並び順をdateの、昇順としてみる
//        diary.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
//        diary.returnsObjectsAsFaults = false
//        var results = viewContext.executeFetchRequest(toDoRequest, error: nil) as [Diary]!
//        memos = []
//        for data in results {
//            memos.append(data.memo)
//        }
//        
//        // テーブル情報を更新する
//        self.cell.reloadData()
        
        titleTxt.endEditing(true);
        categoryTxt.endEditing(true);
        diaryTxt.resignFirstResponder();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func onDidChangeDate(sender: UIDatePicker){
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        
//        print(formatter)
//        //型変換
//        dateTxt.text = formatter.string(from: sender.date)
//        selectedDate = sender.date as NSDate
        
        let created2 = DateFormatter()
        created2.dateFormat = "yyyy/MM/dd hh:mm:ss"
        created2.timeZone = TimeZone.current
        
        var strDateTmp = created2.string(from: Date())
        var changeDate = created2.date(from: strDateTmp)
        
        //coreDataに設定
        created2.setValue(changeDate, forKey: "created2")
        
                dateTxt.text = created2.string(from: sender.date)
                selectedDate = sender.date as NSDate
        
//        //キーボード上部に表示
//        UIView *inputAccessoryView = UIDatePicker
//        self.dateTxt.inputAccessoryView = inputAccessoryView;
    }
    
    internal func onClickButton(sender: UIButton){
        dateTxt.endEditing(true);
    }
    
    //本日の日付を表示する
    internal func onNowButton(sender: UIButton){
        //本日の日付を表示
        let now = Date()
        //日本標準日付を表示
        let jaLocale = Locale(identifier: "ja_JP")
        //DateFormatterを宣言
        let formatter = DateFormatter()
        //dateのformatを指定
        formatter.dateFormat = "yyyy/MM/dd"
        //nowからtext型で持ってくる
        dateTxt.text = formatter.string(from: now)
        //now.description(with: jaLocale)をdateTxt.textに代入
        //dateTxt.text = now.description(with: jaLocale)
        print(now.description(with: jaLocale))
        //dateTxtを入力したらdatePickerを閉じる
        dateTxt.endEditing(true);
    }
}

