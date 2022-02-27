//
//  ActionCollectionViewCell.swift
//  quiz2022
//
//  Created by Anderson Chen on 2022/2/27.
//

import UIKit

class ActionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(index: Int) {
        view.layer.cornerRadius = 10
        imageView.image = UIImage(systemName: index == 0 ? "house.fill" : "map.fill")
        label.text = index == 0 ? "旅店資訊" : "旅店導航"
    }
}
