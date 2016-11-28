//
//  FirstViewController.swift
//  myAprication004
//
//  Created by Apple on 2016/11/18.
//  Copyright © 2016年 Takahiro Ono. All rights reserved.
//

import UIKit
import CoreData

class createDiaryViewController: UIViewController {
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var nyCreateBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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

