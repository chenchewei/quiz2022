//
//  ViewController.swift
//  quiz2022
//
//  Created by Anderson Chen on 2022/2/26.
//

import UIKit
import Toast_Swift
import MapKit

class ViewController: NotificationVC {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var button_search: UIButton!
    @IBOutlet weak var button_history: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    private let mapManager: CLLocationManager = CLLocationManager()
    private var data: LandscapeRes.Result? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
        getDataFromAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 14.0, *) {
            if mapManager.authorizationStatus == .notDetermined {
                mapManager.requestWhenInUseAuthorization()
            }
            mapManager.startUpdatingLocation()
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func APINotificationReceiver(notification: NSNotification) {
        super.APINotificationReceiver(notification: notification)
        DispatchQueue.main.async {
            if let res = notification.object as? LandscapeRes {
                self.handleLandscapeRes(res: res)
            }
        }
    }

    private func componentsInit() {
        title = "景點搜尋"
        searchBar.placeholder = "名稱、地址搜尋"
        button_search.layer.cornerRadius = 5
        button_history.layer.cornerRadius = 5
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "mapView")
        mapManager.delegate = self
        mapManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let userLocation = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshUserLocation))
        navigationItem.rightBarButtonItem = userLocation
    }
    
    private func getDataFromAPI() {
        APIManager.doGetAPIData()
    }
    
    private func handleLandscapeRes(res: LandscapeRes) {
        data = res.results
        setAnnotations()
    }
    /// 設置mapView上的座標點
    private func setAnnotations() {
        guard let data = data else { return }
        for (_, content) in data.content.enumerated() {
            let annotation: MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(content.lat, content.lng)
            annotation.title = content.name
            annotation.subtitle = content.vicinity
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    /// 調整地圖視角至使用者位置
    @objc private func refreshUserLocation() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
}

extension ViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            print("didUpdateLocations")
        }
    }
}
