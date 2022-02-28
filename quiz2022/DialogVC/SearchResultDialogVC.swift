//
//  SearchResultDialogVC.swift
//  quiz2022
//
//  Created by Anderson Chen on 2022/2/27.
//

import UIKit
import CoreLocation

protocol SearchResultDialogVCDelegate: AnyObject {
    func setMapRegion(lat: CLLocationDegrees, lng: CLLocationDegrees)
    func historyDidClear()
}

class SearchResultDialogVC: UIViewController {

    @IBOutlet weak var view_dialog: UIView!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button_clear: UIButton!
    
    weak var delegate: SearchResultDialogVCDelegate? = nil
    private var mode: Mode = .result
    private var results: [LandscapeRes.Contents]? = nil
    private var defaultsArray: [LandscapeRes.Contents] = [LandscapeRes.Contents]()
    
    enum Mode {
        case result
        case history
    }
    
    convenience init(mode: Mode = .result, results: [LandscapeRes.Contents]? = nil) {
        self.init()
        self.mode = mode
        self.results = results
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentInit()
    }
    
    private func componentInit() {
        if let data = getDefaultData() {
            defaultsArray = data
        }
        view_dialog.layer.cornerRadius = 10
        button_clear.layer.cornerRadius = 5
        label_title.text = mode == .result ? "搜尋紀錄" : "搜尋結果"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissDialog))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        button_clear.isHidden = mode == .result
    }
    
    private func updateDefaultsData() {
        let data = try? defaultsArray.toData()
        UserDefaults().set(data, forKey: "searchHistory")
        UserDefaults().synchronize()
    }
    
    private func getDefaultData() -> [LandscapeRes.Contents]? {
        guard let data = UserDefaults().object(forKey: "searchHistory") as? Data else { return nil }
        let array = try? JSONDecoder().decode([LandscapeRes.Contents].self, from: data)
        return array
    }

    @IBAction func clearButtonTouchUpInside(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "searchHistory")
        tableView.reloadData()
        delegate?.historyDidClear()
    }
    
    @objc private func dismissDialog() {
        dialogDismiss()
    }

}

extension SearchResultDialogVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case .result:
            guard let results = results else { return 0 }
            return results.count
        case .history:
            return defaultsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        
        switch mode {
        case .result:
            guard let results = results else { return UITableViewCell() }
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.attributedText = NSAttributedString(string: results[indexPath.row].name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)])
                content.secondaryAttributedText = NSAttributedString(string: results[indexPath.row].vicinity, attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])
                content.textProperties.adjustsFontSizeToFitWidth = true
                content.textProperties.minimumScaleFactor = 0.85
                content.textProperties.alignment = .natural
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = results[indexPath.row].name
                cell.textLabel?.textColor = .black
                cell.detailTextLabel?.text = results[indexPath.row].vicinity
                cell.detailTextLabel?.textColor = .orange
                cell.textLabel?.adjustsFontSizeToFitWidth = true
                cell.textLabel?.minimumScaleFactor = 0.85
                cell.textLabel?.textAlignment = .natural
            }
        case .history:
            let reverseArray: [LandscapeRes.Contents] = defaultsArray.reversed()
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.attributedText = NSAttributedString(string: reverseArray[indexPath.row].name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)])
                content.secondaryAttributedText = NSAttributedString(string: reverseArray[indexPath.row].vicinity, attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])
                content.textProperties.adjustsFontSizeToFitWidth = true
                content.textProperties.minimumScaleFactor = 0.85
                content.textProperties.alignment = .natural
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = reverseArray[indexPath.row].name
                cell.textLabel?.textColor = .black
                cell.detailTextLabel?.text = reverseArray[indexPath.row].vicinity
                cell.detailTextLabel?.textColor = .orange
                cell.textLabel?.adjustsFontSizeToFitWidth = true
                cell.textLabel?.minimumScaleFactor = 0.85
                cell.textLabel?.textAlignment = .natural
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch mode {
        case .result:
            guard let results = results, results.indices.contains(indexPath.row) else { return }
            // 如果已經選過，就不再加一次
            if !defaultsArray.isEmpty {
                for (_, item) in defaultsArray.enumerated() where item.name == results[indexPath.row].name {
                    delegate?.setMapRegion(lat: results[indexPath.row].lat, lng: results[indexPath.row].lng)
                    return
                }
            }
            defaultsArray.append(results[indexPath.row])
            // 更新defaults
            updateDefaultsData()
            // 跳轉map
            delegate?.setMapRegion(lat: results[indexPath.row].lat, lng: results[indexPath.row].lng)
        case .history:
            // 跳轉map
            let reverseArray: [LandscapeRes.Contents] = defaultsArray.reversed()
            delegate?.setMapRegion(lat: reverseArray[indexPath.row].lat, lng: reverseArray[indexPath.row].lng)
        }
    }
    
}
