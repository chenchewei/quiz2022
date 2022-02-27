//
//  NotificationVC.swift
//  quiz2022
//
//  Created by Anderson Chen on 2022/2/27.
//

import UIKit
import Toast_Swift

class NotificationVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationsInit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deinitNotifications()
    }
    /// API監聽處理
    @objc func APINotificationReceiver(notification: NSNotification) {
        
    }
    /// API發送失敗監聽處理
    @objc func APIFailedNotificationReceiver(notification: NSNotification) {

    }
    
    /// 鍵盤升起
    func keyboardWillShow(duration: Double, height: CGFloat) {
        
    }
    /// 鍵盤下降
    func keyboardWillHide(duration: Double) {
        
    }
    
    private func notificationsInit() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(APINotificationReceiver), name: Notification.Name("APINotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(APIFailedNotificationReceiver), name: Notification.Name("APIFailedNotification"), object: nil)
    }
    
    @objc fileprivate func keyboardWillShowReceiver(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double, let size = keyboardFrame?.cgRectValue else { return }
        keyboardWillShow(duration: duration, height: size.height)
    }

    @objc fileprivate func keyboardWillHideReceiver(notification: NSNotification) {
        let userInfo = notification.userInfo
        guard let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        keyboardWillHide(duration: duration)
    }

    private func deinitNotifications() {
        // 這裡把廣播一個一個去做刪除 而不使用NotificationCenter.default.removeObserver(self)來全部刪除
        // 因為有些頁面有自己的廣播必須保留不要被刪除 例如:videoListVC的廣播
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("APINotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("FCMNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
}
