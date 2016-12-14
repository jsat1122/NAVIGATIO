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
import Foundation //追加
import CoreLocation //追加


class MainViewController: UIViewController ,UISearchBarDelegate ,MKMapViewDelegate , UIApplicationDelegate , CLLocationManagerDelegate{
    
    let annotation1 = TestMKPointAnnotation()
    let annotation2 = TestMKPointAnnotation()
    var line = MKPolyline() //直線
    // ピンを生成.
    let myPin: MKPointAnnotation = MKPointAnnotation()
    
    var testManager:CLLocationManager = CLLocationManager() //現在地
    
    
    //配列の定義
    var diaryArray :[NSDictionary] = []
    var dairyDic :NSDictionary! = [:]
    
    @IBOutlet weak var createDiaryBtn: UIButton!
    @IBOutlet weak var listDiaryBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var myMapView: MKMapView = MKMapView()
    var mySearchBar: UISearchBar!
    var myRegion: MKCoordinateRegion!
    
    var composeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            testManager = CLLocationManager()
            //デリゲート先に自分を設定する。
            testManager.delegate = self
            
            //位置情報の取得を開始する。
            testManager.startUpdatingLocation()
            
            //位置情報の利用許可を変更する画面をポップアップ表示する。
            testManager.requestWhenInUseAuthorization()
            
            
            //NavigationBarを表示させ始める
            self.navigationController?.isNavigationBarHidden = false
            
            
            // Do any additional setup after loading the view.
            
            // NavigationBarにボタン作成
            // barButtonSystemItemを変更すればいろいろなアイコンに変更できます
            composeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: "clickComposeButton")
            
            var organizeButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.organize, target: self, action: "clickorganizeButton")
            
            //ナビゲーションバーの右側にボタン付与
            self.navigationItem.setRightBarButtonItems([composeButton, organizeButton], animated: true)
            
            
            
            //        // 経度緯度を設定.
            //        let myLan: CLLocationDegrees = 37.331741
            //        let myLon: CLLocationDegrees = -122.030333
            //
            //        let x = 140.000000 //経度
            //        let y = 35.000000  //緯度
            //
            //        //中心座標
            //        let center = CLLocationCoordinate2DMake(y, x)
            
            //        //表示範囲
            //        let span = MKCoordinateSpanMake(1.0, 1.0)
            //
            //        //中心座標と表示範囲をマップに登録する。
            //        let region = MKCoordinateRegionMake(center, span)
            //        myMapView.setRegion(region, animated:true)
            
            //        // MapViewのサイズを画面全体に.
            //        myMapView.frame = self.view.bounds
            
            // Delegateを設定.
            myMapView.delegate = self
            
            // searchBar生成.
            mySearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
            mySearchBar.layer.position = CGPoint(x: self.view.frame.width/2, y: 80)
            mySearchBar.delegate = self
            mySearchBar.layer.shadowColor = UIColor.blue.cgColor
            mySearchBar.layer.shadowOpacity = 0.5
            mySearchBar.layer.masksToBounds = false
            mySearchBar.showsCancelButton = true
            mySearchBar.showsBookmarkButton = false
            mySearchBar.prompt = "ローカル検索"
            mySearchBar.placeholder = "ここに入力してください"
            mySearchBar.tintColor = UIColor.red
            mySearchBar.showsSearchResultsButton = false
            
            // searchBarをviewに追加.
            self.view.addSubview(mySearchBar)
            
            //fontAwesome
            createDiaryBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
            createDiaryBtn.setTitle(String.fontAwesomeIcon(name: .plus), for: .normal)
            
            listDiaryBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
            listDiaryBtn.setTitle(String.fontAwesomeIcon(name: .listUL), for: .normal)
            
            // MapViewを生成.
            dispMap.frame = self.view.frame
            
            // デリゲートを設定.
            dispMap.delegate = self
            
            // 経度、緯度を生成.
            let myLatitude: CLLocationDegrees = 37.331741
            let myLongitude: CLLocationDegrees = -122.030333
            
            //        // MapViewに中心点を設定.
            //        dispMap.setCenter(center, animated: true)
            
            //ルート検索
            // 目的地の緯度、経度を設定.
            let requestLatitude: CLLocationDegrees = 37.427474
            let requestLongitude: CLLocationDegrees = -122.169719
            
            // 目的地の座標を指定.
            let requestCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(requestLatitude, requestLongitude)
            let fromCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)
            
            // 地図の中心を出発点と目的地の中間に設定する.
            let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake((myLatitude + requestLatitude)/2, (myLongitude + requestLongitude)/2)
            //
            // 縮尺(表示領域)を指定.
            let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let myRegion: MKCoordinateRegion = MKCoordinateRegionMake(center, mySpan)
            
            // MapViewにregionを追加.
            dispMap.region = myRegion
            
            //直線を引くコード
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
            
            
            //検索するコード
            //        // PlaceMarkを生成して出発点、目的地の座標をセット.
            //        let fromPlace: MKPlacemark = MKPlacemark(coordinate: fromCoordinate, addressDictionary: nil)
            //        let toPlace: MKPlacemark = MKPlacemark(coordinate: requestCoordinate, addressDictionary: nil)
            //
            //
            //        // Itemを生成してPlaceMarkをセット.
            //        let fromItem: MKMapItem = MKMapItem(placemark: fromPlace)
            //        let toItem: MKMapItem = MKMapItem(placemark: toPlace)
            //
            //        // MKDirectionsRequestを生成.
            //        let myRequest: MKDirectionsRequest = MKDirectionsRequest()
            //
            //        // 出発地のItemをセット.
            //        myRequest.source = fromItem
            //
            //        // 目的地のItemをセット.
            //        myRequest.destination = toItem
            //
            //        // 複数経路の検索を有効.
            //        myRequest.requestsAlternateRoutes = true
            //
            //        // 移動手段を自由に設定.
            //        myRequest.transportType = MKDirectionsTransportType.any
            //
            //        // MKDirectionsを生成してRequestをセット.
            //        let myDirections: MKDirections = MKDirections(request: myRequest)
            //
            //        // 経路探索.
            //        myDirections.calculate { (response, error) in
            //
            //            // NSErrorを受け取ったか、ルートがない場合.
            //            if error != nil || response!.routes.isEmpty {
            //                return
            //            }
            //
            //            let route: MKRoute = response!.routes[0] as MKRoute
            //            print("目的地まで \(route.distance)km")
            //            print("所要時間 \(Int(route.expectedTravelTime/60))分")
            //
            //            // mapViewにルートを描画.
            //            self.dispMap.add(route.polyline)
            //        }
            //
            //        // ピンを生成.
            //        let fromPin: MKPointAnnotation = MKPointAnnotation()
            //        let toPin: MKPointAnnotation = MKPointAnnotation()
            //
            //        // 座標をセット.
            //        fromPin.coordinate = fromCoordinate
            //        toPin.coordinate = requestCoordinate
            //
            //        // titleをセット.
            //        fromPin.title = "出発地点"
            //        toPin.title = "目的地"
            //
            //
        }
        
        func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            
            if CLLocationManager.locationServicesEnabled() {
                testManager.stopUpdatingLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .notDetermined:
                testManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                break
            case .authorizedAlways, .authorizedWhenInUse:
                break
            }
        }
        
        
        //        var latTextField: UITextView!
        //        var lngTextField: UITextView!
        //
        //        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //            guard let newLocation = locations.last,
        //                CLLocationCoordinate2DIsValid(newLocation.coordinate) else {
        //                    self.latTextField.text = "Error"
        //                    self.lngTextField.text = "Error"
        //                    return
        //            }
        //
        //            self.latTextField.text = "".appendingFormat("%.4f", newLocation.coordinate.latitude)
        //            self.lngTextField.text = "".appendingFormat("%.4f", newLocation.coordinate.longitude)
        //        }
        
        
    }
    
    //位置情報取得時の呼び出しメソッド
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            
            //中心座標
            let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            
            //表示範囲
            let span = MKCoordinateSpanMake(0.01, 0.01)
            
            //中心座標と表示範囲をマップに登録する。
            let region = MKCoordinateRegionMake(center, span)
            myMapView.setRegion(region, animated:true)
            
            //ピンを作成してマップビューに登録する。
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            myMapView.addAnnotation(annotation)
            
        }
    }
    
    func clickComposeButton(){
        //composeButtonを押した際の処理を記述
        let second = storyboard?.instantiateViewController(withIdentifier: "CreateDiaryViewController")
        self.navigationController?.pushViewController(second!, animated: true)
    }
    
    func clickorganizeButton(){
        //organizeButtonを押した際の処理を記述
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        //        self.present(nextView, animated: true, completion: nil)
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    //    // ルートの表示設定.
    //    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    //
    //        let route: MKPolyline = overlay as! MKPolyline
    //        let routeRenderer: MKPolylineRenderer = MKPolylineRenderer(polyline: route)
    //
    //        // ルートの線の太さ.
    //        routeRenderer.lineWidth = 3.0
    //
    //        // ルートの線の色.
    //        routeRenderer.strokeColor = UIColor.red
    //        return routeRenderer
    //
    //        //左下のピン
    //        annotation1.coordinate = CLLocationCoordinate2DMake(-1.0, -1.0)
    //        annotation1.title = "ピン1"
    //        annotation1.subtitle = "\(annotation1.coordinate.latitude), \(annotation1.coordinate.longitude)"
    //        annotation1.pinColor = UIColor.orange
    //        dispMap.addAnnotation(annotation1)
    //
    //        //右上のピン
    //        annotation2.coordinate = CLLocationCoordinate2DMake(+1.0, +1.0)
    //        annotation2.title = "ピン2"
    //        annotation2.subtitle = "\(annotation2.coordinate.latitude), \(annotation2.coordinate.longitude)"
    //        dispMap.addAnnotation(annotation2)
    //        annotation2.pinColor = UIColor.green
    //
    //    }
    
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
        
       
        
        // 座標を設定.
        myPin.coordinate = myCoordinate
        
        // タイトルを設定.　*国名
        myPin.title = "タイトル"
        
        // サブタイトルを設定.　*町名
        myPin.subtitle = "サブタイトル"
        
//        // タイトルを設定.　*国名
//        myPin.title = "タイトル"
//        
//        let button = UIButton()
//        button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
//        button.setTitle("色", for: .normal)
//        button.setTitleColor(UIColor.black, for:.normal)
//        button.backgroundColor = UIColor.yellow
//        
//        
//        
//       // testView.leftCalloutAccessoryView = button
//        
//        // サブタイトルを設定.　*町名
//       // myPin.
        
        // MapViewにピンを追加.
        dispMap.addAnnotation(myPin)
        dispMap.addAnnotation(annotation1)
        
        //        //ピンの色を指定
        //        myPin.pinTintColor = UIColor.purpleColor()
        
        //        //バルーンにボタンをつける
        //        pinView?.canShowCallout = true
        //        let rightButton: AnyObject! = UIButton(type: UIButtonType.detailDisclosure)
        //        pinView?.rightCalloutAccessoryView = rightButton as? UIView
        
    }
    
    
    /*
     addAnnotationした際に呼ばれるデリゲートメソッド.
     */
    func mapView(mapView: MKMapView, viewFor
        annotation: MKAnnotation) -> MKAnnotationView? {
        
        let myPinIdentifier = "PinAnnotationIdentifier"
        
        // ピンを生成.
        let myPinView = MKPinAnnotationView(annotation: annotation1, reuseIdentifier: myPinIdentifier)
        
        // アニメーションをつける.
        myPinView.animatesDrop = true
        
        // コールアウトを表示する.
        myPinView.canShowCallout = true
        
        // annotationを設定.
        myPinView.annotation = annotation1
        
        
        return myPinView
    }
    
    //アノテーションビューを返すメソッド
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        let myPinIdentifier = "PinAnnotationIdentifier"
        
        // ピンを生成.
        var testView = self.myMapView.dequeueReusableAnnotationView(withIdentifier: myPinIdentifier) as? MKPinAnnotationView
        
        if testView != nil {
            testView!.annotation = annotation
        } else {
            testView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)
        }
    
        //吹き出しを表示可能にする。
        testView?.canShowCallout = true
        
//        //左ボタンをアノテーションビューに追加する。
//        let button = UIButton()
//        button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
//        button.setTitle("色", for: .normal)
//        button.setTitleColor(UIColor.black, for:.normal)
//        button.backgroundColor = UIColor.yellow
//        testView.leftCalloutAccessoryView = button
//        //myPin.title = String(describing: button)
//        
//        
//        //右ボタンをアノテーションビューに追加する。
//        let button2 = UIButton()
//        button2.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
//        button2.setTitle("削除", for: .normal)
//        button2.backgroundColor = UIColor.red
//        button2.setTitleColor(UIColor.white, for:.normal)
//        testView.rightCalloutAccessoryView = button2
        //myPin.subtitle = String(describing: button2)
        
        var infoBtn = UIButton(type: UIButtonType.detailDisclosure)
        infoBtn.addTarget(self, action: "tapBtn", for: UIControlEvents.touchUpInside)
        
        testView?.rightCalloutAccessoryView = infoBtn
        
        
        //ドラッグ可能にする。
        testView?.isDraggable = true
        
        //ピンの色を設定する。
        if let test = annotation as? TestMKPointAnnotation {
            testView?.pinTintColor = test.pinColor
        }
        
        return testView
        
    }
    
    func tapBtn(){
        
        print("ピンの中のボタンタップしました")
    }
    
    //ドラッグ＆ドロップ時の呼び出しメソッド
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        //ピンを離した場合
        if(newState == .ending){
            
            if let test = view.annotation as? MKPointAnnotation {
                //ピンのサブタイトルを最新の座標にする。
                test.subtitle = "\(Double(test.coordinate.latitude)), \(Double(test.coordinate.longitude))"
            }
            
            //前回の描画を削除する。
            mapView.remove(line)
            
            //始点と終点の座標
            var location:[CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: annotation1.coordinate.latitude, longitude: annotation1.coordinate.longitude),
                                                     CLLocationCoordinate2D(latitude: annotation2.coordinate.latitude, longitude: annotation2.coordinate.longitude)]
            
            //2点間に直線を描画する。
            line = MKPolyline(coordinates: &location, count: 2)
            mapView.add(line)
        }
    }
    //描画メソッド実行時の呼び出しメソッド
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let testRender = MKPolylineRenderer(overlay: overlay)
        
        //直線の幅を設定する。
        testRender.lineWidth = 3
        
        //直線の色を設定する。
        testRender.strokeColor = UIColor.red
        
        return testRender
    }
    
    /*
     addOverlayした際に呼ばれるデリゲートメソッド.
     */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // rendererを生成.
        let myPolyLineRendere: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        // 線の太さを指定.
        myPolyLineRendere.lineWidth = 3
        
        // 線の色を指定.
        myPolyLineRendere.strokeColor = UIColor.red
        
        return myPolyLineRendere
    }
    
    
    
    
    //吹き出しアクササリー押下時の呼び出しメソッド
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if(control == view.leftCalloutAccessoryView) {
            
            //左のボタンが押された場合はピンの色をランダムに変更する。
            if let pinView = view as? MKPinAnnotationView {
                pinView.pinTintColor = UIColor(red: CGFloat(drand48()),
                                               green: CGFloat(drand48()),
                                               blue: CGFloat(drand48()),
                                               alpha: 1.0)
            }
        } else {
            
            //右のボタンが押された場合はピンを消す。
            mapView.removeAnnotation(view.annotation!)
        }
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        for view in views {
            view.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var dispMap: MKMapView!
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //①キーボードを閉じる
        mySearchBar.resignFirstResponder()
        
        //②入力された文字を取り出す
        let serchKeyword = mySearchBar.text
        
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
        
        //        //一件取得
        //        var df = DateFormatter()
        //        df.dateFormat = "yyyy/MM/dd" //"yyyy/MM/dd hh:mm:ss +0000"
        //        df.timeZone = TimeZone.current
        //        //保存していた日付を文字列からDate型に変換
        //        var savedDateTime:NSDate = df.date(from: "\(myAp.myCount)") as! NSDate
        //        print(savedDateTime)
        //        //検索条件として指定
        //        let predicate = NSPredicate(format: "SELF.created_at = %@", savedDateTime )
        //        query.predicate = predicate
        
        do {
            
            let fetchResults = try viewContext.fetch(query)
            for result: AnyObject in fetchResults {
                let title: String? = result.value(forKey: "title") as? String
                let date: Date = result.value(forKey: "date") as! Date
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
            //fatalError("Failed to fetch diary: \(error)")
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
