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

extension UIImage{
    
    // Resizeのクラスメソッドを作る.
    class func ResizeÜIImage(image : UIImage,width : CGFloat, height : CGFloat)-> UIImage!{
        
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        // コンテキストに画像を描画する.
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // コンテキストからUIImageを作る.
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

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
        
        // 画像の設定.
        let myImage:UIImage = UIImage(named:"japan.png")!
        
        // リサイズされたUIImageを指定して、UIImageViewを作る.
        let myImageView = UIImageView(image: UIImage.ResizeÜIImage(image: myImage, width: self.view.frame.maxX, height: self.view.frame.maxY))
        
        // 透過する.
        myImageView.alpha = 0.05
        
        // viewにUIImageViewを追加.
        self.view.addSubview(myImageView)
        
        
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
    
    //アラート表示
    func showAlert(message:String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func diaryCreate(_ sender: UIButton) {
        
        
        //テキストが空の時にアラート表示
        //        var alertController: UIAlertController = textFieldShouldReturn(_, textField: UITextField) -> Bool {
        var titleString = self.titleTxt.text
        var dateString = self.dateTxt.text
        var categoryString = self.categoryTxt.text
        var diaryString = self.diaryTxt.text
        
        
        titleString = titleString?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if titleString == ""{
            //alert title
            self.showAlert(message: "Please enter title")
            
            return
        }
        if dateString == ""{
            //alert date
            self.showAlert(message: "Please enter date")
            return
        }
        if categoryString == ""{
            //alert category
            self.showAlert(message: "Please enter category")
            return
        }
        if diaryString == ""{
            //alert diary
            self.showAlert(message: "Please enter diary")
        }


        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let diary = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext) //全ての日記を取得
        let newRecord = NSManagedObject(entity: diary!, insertInto: viewContext)
        
    
        //型変換
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateTextDate:Date = dateFormatter.date(from: dateTxt.text!)!
        
        newRecord.setValue(titleTxt.text, forKey: "title") //値を代入
        newRecord.setValue(dateTextDate, forKey: "date")//値を代入
        newRecord.setValue(categoryTxt.text, forKey: "category")//値を代入
        newRecord.setValue(diaryTxt.text, forKey: "diary")//値を代入
        newRecord.setValue(ImagView.image, forKey: "image")//値を代入
        
        do {
            try viewContext.save()
        } catch {
        }
        
        
                        //titleTxt からフォーカスを外すことによってキーボードを消す
//            self.titleTxt.resignFirstResponder(){
//                        return true
//                    }
//            self.categoryTxt.resignFirstResponder()
//                        return true
//                    }
//            self.diaryTxt.resignFirstResponder()
//                    }
        
    

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
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        titleTxt.endEditing(true);
        categoryTxt.endEditing(true);
        diaryTxt.resignFirstResponder();
    }
    
    
    
    internal func onDidChangeDate(sender: UIDatePicker){
        
        let created2 = DateFormatter()
        created2.dateFormat = "yyyy/MM/dd" //"yyyy/MM/dd hh:mm:ss"
        created2.timeZone = TimeZone.current
        
        var strDateTmp = created2.string(from: Date())
        var changeDate = created2.date(from: strDateTmp)
        
//        //coreDataに設定
//        created2.setValue(changeDate, forKey: "created2")
//        
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
    
    //GestureRecognizerのdelegateをselfに設定して使用する
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer
        otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
        return true
    }
    
}
