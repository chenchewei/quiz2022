//
//  AnnotationDetailVC.swift
//  quiz2022
//
//  Created by Anderson Chen on 2022/2/27.
//

import UIKit
import SDWebImage

class AnnotationDetailVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_address: UILabel!
    @IBOutlet weak var collectionView_stars: UICollectionView!
    @IBOutlet weak var flowLayout_star: UICollectionViewFlowLayout!
    @IBOutlet weak var constraint_starWidth: NSLayoutConstraint!
    @IBOutlet weak var label_photos: UILabel!
    @IBOutlet weak var collectionView_scene: UICollectionView!
    @IBOutlet weak var constraint_sceneHeight: NSLayoutConstraint!
    @IBOutlet weak var flowLayout_scene: UICollectionViewFlowLayout!
    
    private var data: LandscapeRes.Contents? = nil
    
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
        title = "詳細資訊"
        guard let data = data else { return }
        imageView.sd_setImage(with: URL(string: data.photo), placeholderImage: UIImage(systemName: "cloud.sun.fill"))
        label_name.text = data.name
        label_address.text = data.vicinity
        label_photos.text = "景觀圖(\(data.landscape.count))"
    }

    private func collectionViewInit() {
        guard let data = data else { return }

        collectionView_stars.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "starCell")
        collectionView_scene.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "sceneCell")
        
        flowLayout_star.itemSize = CGSize(width: 45, height: 45)
        flowLayout_star.minimumLineSpacing = 5
        flowLayout_star.minimumInteritemSpacing = 0
        flowLayout_star.scrollDirection = .horizontal
        flowLayout_star.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        constraint_starWidth.constant = CGFloat(45 * data.star) + CGFloat(5 * (data.star - 1))
        collectionView_stars.reloadData()
        let row = ceil(Float(data.landscape.count) / 3.0)
        constraint_sceneHeight.constant = CGFloat(row * 90)
        let divider: CGFloat = row > 1 ? 2 : 3
        flowLayout_scene.itemSize = CGSize(width: (UIScreen.main.bounds.width - 40 - 5 * 2) / divider, height: 90)
        flowLayout_scene.minimumLineSpacing = 5
        flowLayout_scene.minimumInteritemSpacing = 0
        flowLayout_scene.scrollDirection = .horizontal
        flowLayout_scene.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView_scene.reloadData()
        
    }
}

extension AnnotationDetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = data else { return 0 }
        return collectionView.tag == 0 ? data.star : data.landscape.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isScene: Bool = collectionView.tag == 1
        let sceneWidth: CGFloat = (UIScreen.main.bounds.width - 40 - 5 * 2) / 3
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: isScene ? sceneWidth : 45, height: isScene ? 90 : 45))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = isScene ? .brown : #colorLiteral(red: 0.9254261364, green: 0.7799510232, blue: 0.1985844731, alpha: 1)
        guard let data = data else { return UICollectionViewCell() }
        if isScene {
            imageView.sd_setImage(with: URL(string: data.landscape[indexPath.row]), placeholderImage: UIImage(systemName: "arrow.2.circlepath.circle.fill"))
        } else {
            imageView.image = UIImage(systemName: "star.fill")
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: isScene ? "sceneCell" : "starCell", for: indexPath)
        cell.contentView.addSubview(imageView)
        cell.bringSubviewToFront(imageView)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.tag == 1, let data = data else { return }
        let index: Int = indexPath.row
        let VC = PhotoDetailVC(photos: data.landscape, index: index)
        navigationController?.pushViewController(VC, animated: true)
    }
    
}
