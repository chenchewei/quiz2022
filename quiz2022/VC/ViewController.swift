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

extension ViewController: CLLocationManagerDelegate {
    
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

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard !(view.annotation?.isKind(of: MKUserLocation.self) ?? false) else { return }
        guard let data = data?.content else { return }
        let index: Int = data.firstIndex(where: { $0.name == view.annotation?.title ?? "" }) ?? 0
        guard data.indices.contains(index) else { return }
        showActionDialogVC(data: data[index])
    }
}

extension ViewController: ActionDialogVCDelegate {
    func dismissDialogWithoutAction() {
        removePresented(animator: .fade) { [weak self] in
            guard let self = self else { return }
            self.mapView.deselectAnnotation(self.mapView.selectedAnnotations.first, animated: true)
        }
    }
    
    func showAnnotationDetail(data: LandscapeRes.Contents) {
        mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
        removePresented(animator: .fade) { [weak self] in
            guard let self = self else { return }
            let VC = AnnotationDetailVC(data: data)
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func navigateToMap(lat: CLLocationDegrees, lng: CLLocationDegrees) {
        mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
        removePresented(animator: .fade) {
            // 終點座標
            let targetCoordinate = CLLocationCoordinate2DMake(lat, lng)
            // 初始化 MKPlacemark
            let targetPlacemark = MKPlacemark(coordinate: targetCoordinate)
            // 透過 targetPlacemark 初始化一個 MKMapItem
            let targetItem = MKMapItem(placemark: targetPlacemark)
            // 使用當前使用者當前座標初始化 MKMapItem
            let userMapItem = MKMapItem.forCurrentLocation()
            // 建立導航路線的起點及終點 MKMapItem
            let routes = [userMapItem,targetItem]
            // 透過 launchOptions 選擇我們的導航模式，例如：開車、走路等等...
            // 不切換執行緒會閃退
            DispatchQueue.main.async {
                MKMapItem.openMaps(with: routes, launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }
            
        }
        
    }
    
    
}
