//
//  MainViewController.swift
//  myAprication004
//
//  Created by Apple on 2016/11/18.
//  Copyright © 2016年 Takahiro Ono. All rights reserved.
//

import UIKit
import MapKit //追加
import FontAwesome_swift //追加
import CoreData //追加


class MainViewController: UIViewController ,UISearchBarDelegate ,MKMapViewDelegate{
    @IBOutlet weak var createDiaryBtn: UIButton!
    @IBOutlet weak var listDiaryBtn: UIButton!
    @IBOutlet weak var serchText: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NavigationBarを表示させ始める
        self.navigationController?.isNavigationBarHidden = false

        // Do any additional setup after loading the view.
        
        //入力のヒントになる、プレースホルダーを設定
        serchText.placeholder = "国名・地域名を入力してください"
        
        //Search Barのdelegate通知先の設定
        serchText.delegate = self
        
        //fontAwesome
        createDiaryBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        createDiaryBtn.setTitle(String.fontAwesomeIcon(name: .plus), for: .normal)
        
        listDiaryBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        listDiaryBtn.setTitle(String.fontAwesomeIcon(name: .listUL), for: .normal)
        
        // MapViewを生成.
//        dispMap = MKMapView()
        dispMap.frame = self.view.frame
        
        // デリゲートを設定.
        dispMap.delegate = self

        // 経度、緯度を生成.
        let myLatitude: CLLocationDegrees = 37.331741
        let myLongitude: CLLocationDegrees = -122.030333
        
        // 中心点を指定.
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        
        // MapViewに中心点を設定.
        dispMap.setCenter(center, animated: true)
        
//        // 縮尺(表示領域)を指定.
//        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let myRegion: MKCoordinateRegion = MKCoordinateRegionMake(center, mySpan)
//        
//        // MapViewにregionを追加.
//        dispMap.region = myRegion
//        
//        // viewにMapViewを追加.
//        self.view.addSubview(dispMap)
//        
//        // 直線を引く座標を作成.
//        let coordinate_1 = CLLocationCoordinate2D(latitude: 37.301741, longitude: -122.050333)
//        let coordinate_2 = CLLocationCoordinate2D(latitude: 37.351951, longitude: -122.020314)
//        let coordinate_3 = CLLocationCoordinate2D(latitude: 37.301741, longitude: -122.020314)
//        let coordinate_4 = CLLocationCoordinate2D(latitude: 37.351951, longitude: -122.050333)
//        
//        // 座標を配列に格納.
//        var coordinates_1 = [coordinate_1, coordinate_2]
//        var coordinates_2 = [coordinate_3, coordinate_4]
//        
//        // polyline作成.
//        let myPolyLine_1: MKPolyline = MKPolyline(coordinates: &coordinates_1, count: coordinates_1.count)
//        let myPolyLine_2: MKPolyline = MKPolyline(coordinates: &coordinates_2, count: coordinates_2.count)
//        
//        // mapViewにcircleを追加.
//        dispMap.add(myPolyLine_1)
//        dispMap.add(myPolyLine_2)

        
        }
    /*
     長押しを感知した際に呼ばれるメソッド.
     */
    
    @IBAction func mapLongPress(_ sender: UILongPressGestureRecognizer) {
        
        print("LongPress")
        
        // 長押しの最中に何度もピンを生成しないようにする.
        if sender.state != UIGestureRecognizerState.began {
            return
        }
        
        // 長押しした地点の座標を取得.
        let location = sender.location(in: dispMap)
        
         //locationをCLLocationCoordinate2Dに変換.
        let myCoordinate: CLLocationCoordinate2D = dispMap.convert(location, toCoordinateFrom: dispMap)
        
        // ピンを生成.
        let myPin: MKPointAnnotation = MKPointAnnotation()
        
        // 座標を設定.
        myPin.coordinate = myCoordinate
        
        // タイトルを設定.　*国名
        myPin.title = "タイトル"
        
        // サブタイトルを設定.　*町名
        myPin.subtitle = "サブタイトル"
        
        // MapViewにピンを追加.
        dispMap.addAnnotation(myPin)
    }
    
        
        /*
         addAnnotationした際に呼ばれるデリゲートメソッド.
         */
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let myPinIdentifier = "PinAnnotationIdentifier"
            
            // ピンを生成.
            let myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)
            
            // アニメーションをつける.
            myPinView.animatesDrop = true
            
            // コールアウトを表示する.
            myPinView.canShowCallout = true
            
            // annotationを設定.
            myPinView.annotation = annotation
            
            return myPinView
        }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var dispMap: MKMapView!
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //①キーボードを閉じる
        serchText.resignFirstResponder()
        
        //②入力された文字を取り出す
        let serchKeyword = serchText.text
        
        //③入力された文字をデバックエリアに表示
        print(serchKeyword)
        
        //ピンを表示する
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(9.56304, 123.415926)
        self.dispMap.addAnnotation(annotation)
        

//        //緯度・経度を設定
        let location:CLLocationCoordinate2D
        = CLLocationCoordinate2DMake(9.56304, 123.415926)
        
        
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
        
//        //④デフォルト動作を行うのでtrueを返す
//        return true
    }
    @IBAction func changeMapButtonAction(_ sender: UIButton) {
        //mapTypeプロパティー値をトグル
        //　標準(.standard) →　航空写真(.satellite) →　航空写真＋標準（.hybrid）
        // →　3D Flyover(.satelliteFlyover) →　3D Flyover標準(.hybridFlyover)
        if dispMap.mapType == .standard{
            dispMap.mapType = .satellite
        }else if dispMap.mapType == .satellite{
            dispMap.mapType = .hybrid
//        }else if dispMap.mapType == .hybrid{
//            dispMap.mapType = .satelliteFlyover
//        }else if dispMap.mapType == .satelliteFlyover{
//            dispMap.mapType = .hybridFlyover
        }else{
            dispMap.mapType = .standard
        }

    }
    @IBAction func myListPushBtn(_ sender: UIButton) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let query: NSFetchRequest<Diary> = Diary.fetchRequest()
        
        do {
            let fetchResults = try viewContext.fetch(query)
            for result: AnyObject in fetchResults {
                let title: String? = result.value(forKey: "title") as? String
                let date: Date? = result.value(forKey: "date") as? Date
                let category: String? = result.value(forKey: "category") as? String
                let diary: String? = result.value(forKey: "diary") as? String
                let image: String? = result.value(forKey: "image") as? String

                print("title:\(title)")
                print("date:\(date)")
                print("category:\(category)")
                print("diary:\(diary)")
                print("image:\(image)")
            }
        } catch {
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
