//
//  UIViewController+.swift
//  quiz2022
//
//  Created by Anderson Chen on 2022/2/26.
//

import UIKit

extension UIViewController {
    /// 點鍵盤外 會隱藏鍵盤
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        print("UIViewController touchesBegan")
    }
}
