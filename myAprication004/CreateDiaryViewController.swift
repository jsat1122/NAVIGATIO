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


class CreateDiaryViewController: UIViewController {
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var nyCreateBtn: UIButton!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var categoryTxt: UITextField!
    
    @IBAction func dateCreate(_ sender: UITextField) {
        let now = Date()
        let jaLocale = Locale(identifier: "ja_JP")
        print(now.description(with: jaLocale))
    }
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //入力のヒントになる、プレースホルダーを設定
        titleTxt.placeholder = "タイトルを入力してください"
        dateTxt.placeholder = "日付を入力してください"
        categoryTxt.placeholder = "カテゴリーを入力してください"
        
        
        //fontAwesome
        nyCreateBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        nyCreateBtn.setTitle(String.fontAwesomeIcon(name: .floppyO), for: .normal)
        
        deleteBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        deleteBtn.setTitle(String.fontAwesomeIcon(name: .trashO), for: .normal)
        
    }
    //画面が切り替わる時
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        //もしもセグエの名前がmySegueだったら
        if(segue.identifier == "mySegue"){
            
            
//            //myCountカウントアップして
//            myCount += 1
            
//            //次の画面のtmpCountに、myCountの値を受け渡す
//            var secondVC = segue.destination as! DataViewController
//            secondVC.tmpCount = myCount
       }
        }

    
    @IBAction func deleteAction(_ sender: UIButton) {
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
//        var targetView: AnyObject = self.storyboard!.instantiateViewController(withIdentifier: "MainViewController")
//        self.present(targetView as! UIViewController, animated: true, completion: nil)
        navigationController?.viewControllers.removeLast() //views to pop
//                navigationController?.setViewControllers(MainViewController!, animated: true)

    }
    
    @IBAction func diaryCreate(_ sender: UIButton) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let tweet = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext)
        let newRecord = NSManagedObject(entity: tweet!, insertInto: viewContext)
        newRecord.setValue("値", forKey: "title") //値を代入
        newRecord.setValue(Date(), forKey: "date")//値を代入
        newRecord.setValue("値", forKey: "category")//値を代入
        newRecord.setValue("値", forKey: "diary")//値を代入
        newRecord.setValue("値", forKey: "image")//値を代入
        
        do {
            try viewContext.save()
        } catch {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

