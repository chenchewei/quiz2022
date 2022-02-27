//
//  ActionDialogVC.swift
//  quiz2022
//
//  Created by Anderson Chen on 2022/2/27.
//

import UIKit
import MapKit

protocol ActionDialogVCDelegate: AnyObject {
    func dismissDialogWithoutAction()
    func showAnnotationDetail(data: LandscapeRes.Contents)
    func navigateToMap(lat: CLLocationDegrees, lng: CLLocationDegrees)
}

class ActionDialogVC: UIViewController {

    @IBOutlet weak var view_dialog: UIView!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView_flowLayout: UICollectionViewFlowLayout!
    
    private var data: LandscapeRes.Contents? = nil
    weak var delegate: ActionDialogVCDelegate? = nil
    
    convenience init(data: LandscapeRes.Contents) {
        self.init()
        self.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
        collectionViewInit()
    }
    
    private func componentsInit() {
        view_dialog.layer.cornerRadius = 10
        guard let data = data else { return }
        label_title.text = data.name
    }
    
    private func collectionViewInit() {
        collectionView.register(UINib(nibName: "ActionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView_flowLayout.itemSize = CGSize(width: 130, height: 160)
        collectionView_flowLayout.minimumLineSpacing = 20
        collectionView_flowLayout.minimumInteritemSpacing = 0
        collectionView_flowLayout.scrollDirection = .horizontal
        collectionView_flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.reloadData()
        label_title.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDialog)))
    }
    
    @objc private func dismissDialog() {
        delegate?.dismissDialogWithoutAction()
    }
}

extension ActionDialogVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ActionCollectionViewCell {
            cell.setCell(index: indexPath.row)
            return cell
        }
        return ActionCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = data else { return }
        switch indexPath.row {
        case 0:
            delegate?.showAnnotationDetail(data: data)
        case 1:
            delegate?.navigateToMap(lat: data.lat, lng: data.lng)
        default:
            break
        }
    }
    
}
