//
//  ViewController.swift
//  quiz2022
//
//  Created by Anderson Chen on 2022/2/26.
//

import UIKit
import Toast_Swift

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var button_search: UIButton!
    @IBOutlet weak var button_history: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
    }

    private func componentsInit() {
        title = "景點搜尋"
        button_search.layer.cornerRadius = 5
        button_history.layer.cornerRadius = 5

    }
    
    
    
}

