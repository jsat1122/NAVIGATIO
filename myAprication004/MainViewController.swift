
//
//  MainViewController.swift
//  myAprication004
//
//  Created by Apple on 2016/11/18.
//  Copyright © 2016年 Takahiro Ono. All rights reserved.
//

import UIKit
import MapKit //追加

class MainViewController: UIViewController ,UITextFieldDelegate ,UISearchBarDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Text FIeldのdelegate通知先を設定
        inputText?.delegate = self
        
        //Search Barのdelegate通知先の設定
        serchText.delegate = self
        //入力のヒントになる、プレースホルダーを設定
        serchText.placeholder = "国名・地域名を入力してください"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var dispMap: MKMapView!
    @IBOutlet weak var serchText: UISearchBar!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //①キーボードを閉じる
        textField.resignFirstResponder()
        
        //②入力された文字を取り出す
        let serchKeyword = textField.text
        
        //③入力された文字をデバックエリアに表示
        print(serchKeyword)
        
        //⑤CLGeocoderインスタンスを取得
        let geocoder = CLGeocoder()
        
        //⑥入力された文字から位置情報を取得
        geocoder.geocodeAddressString(serchKeyword!, completionHandler: { (placemarks:[CLPlacemark]?, error:Error?) in
            
            //⑦位置情報が存在する場合１件目の位置情報をplacemarkに取り出す
            if let placemark = placemarks?[0]{
                
                //⑧位置情報から緯度経度が存在する場合、緯度経度をtargetCoordinateに取り出す
                if let targetCoordinate = placemark.location?.coordinate{
                    
                    //⑨緯度経度をデバイスエリアに表示
                    print(targetCoordinate)
                    
                    //⑩MKPointAnnotationインスタンスを取得し、ピンを生成
                    let pin = MKPointAnnotation()
                    
                    //11　ピンの置く場所に緯度経度を設定
                    pin.coordinate = targetCoordinate
                    
                    //12　ピンのタイトルを設定
                    pin.title = serchKeyword
                    
                    //13　ピンを地図に置く
                    self.dispMap.addAnnotation(pin)
                    
                    //14　緯度経度を中心にして半径500mの範囲を表示
                    self.dispMap.region = MKCoordinateRegionMakeWithDistance(targetCoordinate, 500.0, 500.0)
                }
            }
        })
        
        //④デフォルト動作を行うのでtrueを返す
        return true
    }
    @IBAction func changeMapButtonAction(_ sender: UIButton) {
        //mapTypeプロパティー値をトグル
        //　標準(.standard) →　航空写真(.satellite) →　航空写真＋標準（.hybrid）
        // →　3D Flyover(.satelliteFlyover) →　3D Flyover標準(.hybridFlyover)
        if dispMap.mapType == .standard{
            dispMap.mapType = .satellite
        }else if dispMap.mapType == .satellite{
            dispMap.mapType = .hybrid
        }else if dispMap.mapType == .hybrid{
            dispMap.mapType = .satelliteFlyover
        }else if dispMap.mapType == .satelliteFlyover{
            dispMap.mapType = .hybridFlyover
        }else{
            dispMap.mapType = .standard
        }
        
    }
    
    
    @IBAction func returnMenue_save(sague: UIStoryboardSegue){
    }
    
    @IBAction func returnMenue_delete(sague: UIStoryboardSegue){
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
