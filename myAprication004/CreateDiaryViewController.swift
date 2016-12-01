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


class CreateDiaryViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UITextFieldDelegate{
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var nyCreateBtn: UIButton!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var categoryTxt: UITextField!
    @IBOutlet weak var diaryTxt: UITextView!
    @IBOutlet weak var ImagView: UIImageView!
    
//    @IBAction func dateCreate(_ sender: UITextField) {
//        // 遷移するViewを定義する.このas!はswift1.2では as?だったかと。
//        let dateViewController: DateViewController = self.storyboard?.instantiateViewController(withIdentifier: "DateViewController") as! DateViewController
//        // Viewの移動する.
//        self.present(dateViewController, animated: true, completion: nil)
//
//    }
    var strURL: String = ""
    let datepicker: UIDatePicker = UIDatePicker()
    var selectedDate: NSDate = NSDate()
    //下から出てくるviewの設定
    var subView = UIView(frame: CGRect(x:0, y:0, width:100, height: 100))
    let myBoundSize: CGSize = UIScreen.main.bounds.size
    private var closeButton: UIButton!
    
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
        
        
        //viewを見えない位置に追加
        self.subView = UIView(frame: CGRect(x: 0, y: myBoundSize.height, width: myBoundSize.width, height: 220))
        self.subView.backgroundColor = UIColor.white
        dateTxt.inputView = subView
        //subviewの中にボタンを作成する
        closeButton = UIButton()
        closeButton.frame = CGRect(x: myBoundSize.width - 45, y: 0, width: 45, height: 30)
        closeButton.setTitle("close", for: .normal)
        closeButton.setTitleColor(UIColor.blue, for: .normal)
        closeButton.addTarget(self, action: #selector(self.onClickButton(sender:)), for: .touchUpInside)
        self.subView.addSubview(closeButton)
        //datepickerの設定
        datepicker.frame = CGRect(x: 0, y: 30, width: myBoundSize.width, height: 190)
        datepicker.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        datepicker.datePickerMode = UIDatePickerMode.date
        datepicker.addTarget(self, action: #selector(self.onDidChangeDate(sender:)), for: .valueChanged)
        // subviewににDatePickerを表示する
        self.subView.addSubview(datepicker)
        dateTxt.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleTxt.text = ""
        dateTxt.text = ""
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
        let diary = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext)
        let newRecord = NSManagedObject(entity: diary!, insertInto: viewContext)
        newRecord.setValue("値", forKey: "title") //値を代入
        newRecord.setValue(Date(), forKey: "date")//値を代入
        newRecord.setValue("値", forKey: "category")//値を代入
        newRecord.setValue("値", forKey: "diary")//値を代入
        newRecord.setValue("値", forKey: "image")//値を代入
        
        do {
            try viewContext.save()
        } catch {
        }
        navigationController?.viewControllers.removeLast() //views to pop
         titleTxt.endEditing(true);
        categoryTxt.endEditing(true);
        diaryTxt.endEditing(true);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    internal func onDidChangeDate(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        print(formatter)
        dateTxt.text = formatter.string(from: sender.date)
        selectedDate = sender.date as NSDate
    }
    
    internal func onClickButton(sender: UIButton){
        dateTxt.endEditing(true);
    }
}

