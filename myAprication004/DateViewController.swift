//
//  DateViewController.swift
//  myAprication004
//
//  Created by Apple on 2016/11/30.
//  Copyright © 2016年 Takahiro Ono. All rights reserved.
//

import UIKit

class DateViewController: UIViewController /*,UIPickerViewDataSource, UIPickerViewDelegate*/{
    @IBOutlet weak var myPickerView: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

//        // Do any additional setup after loading the view.
//        myPickerView.dataSource = self
//        myPickerView.delegate = self
    }

//    //画面が表示された時
//    override func viewWillAppear(_ animated: Bool) {
//        print("次の画面が表示された時\(tmpCount)回目です")
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    @IBAction func dateCreate(_ sender: UIDatePicker) {
//        – (void)pickerDidChange;:(UIDatePicker*)datePicker
//        {
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//            [dateFormatter setDateFormat:@”yyyy/MM/dd hh:mm”];
//            NSString *dateString = [dateFormatter stringFromDate:datePicker.date];
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@”取得日時” message:dateString delegate:nil cancelButtonTitle:nil otherButtonTitles:@”OK”, nil];
//            [alertView show];
//        }
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
}
