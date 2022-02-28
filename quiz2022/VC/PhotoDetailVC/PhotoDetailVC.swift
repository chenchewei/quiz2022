//
//  PhotoDetailVC.swift
//  quiz2022
//
//  Created by Anderson Chen on 2022/2/28.
//

import UIKit
import SDWebImage

class PhotoDetailVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView_flowLayout: UICollectionViewFlowLayout!
    private var photos: [String] = []
    // 一進到頁面就會觸發didScroll改變index，先擋住
    private var isInit: Bool = true
    private var index: Int = 1 { didSet { title = "\(index + 1)/\(photos.count)" }}
    
    convenience init(photos: [String], index: Int) {
        self.init()
        self.photos = photos
        self.index = index
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isInit = false
        view.layoutIfNeeded()
        /// 等元件＆collectionView執行完 再滾動
        collectionView.setContentOffset(CGPoint(x: Int(UIScreen.main.bounds.size.width) * index, y: 0), animated: false)
    }
    
    private func collectionViewInit() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView_flowLayout.itemSize = UIScreen.main.bounds.size
        collectionView_flowLayout.minimumLineSpacing = 0
        collectionView_flowLayout.minimumInteritemSpacing = 0
        collectionView_flowLayout.scrollDirection = .horizontal
        collectionView_flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.reloadData()
        
    }
}

extension PhotoDetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
        imageView.contentMode = .scaleAspectFit
        guard photos.indices.contains(indexPath.row) else { return cell }
        imageView.sd_setImage(with: URL(string: photos[indexPath.row]))
        cell.addSubview(imageView)
        cell.bringSubviewToFront(imageView)
        
        return cell
    }
    
}

extension PhotoDetailVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionView, !isInit else { return }
        let offsetX: CGFloat = scrollView.contentOffset.x
        
        let page: CGFloat = round(offsetX / UIScreen.main.bounds.size.width)
        index = Int(page)
        
    }
}
