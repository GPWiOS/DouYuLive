//
//  RecommendViewController.swift
//  DouYuTV
//
//  Created by GaiPengwei on 2017/5/11.
//  Copyright © 2017年 GaiPengwei. All rights reserved.
//

import UIKit

private let kItemMargin : CGFloat = 10
private let kHeaderViewH : CGFloat = 50

private let kNormalCellID = "kNormalCellID"
private let kHeaderViewID = "kHeaderViewID"

let kPrettyCellID = "kPrettyCellID"
let kNormalItemW = (kScreenW - 3 * kItemMargin) / 2
let kNormalItemH = kNormalItemW * 3 / 4
let kPrettyItemH = kNormalItemW * 4 / 3
// 推荐分组的数量
private let kSectionCount : Int = 12

class RecommendViewController: UIViewController {
    
    
    // MARK - 懒加载
    fileprivate lazy var collectionView : UICollectionView = { [unowned self] in
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.itemSize = CGSize(width: kNormalItemW, height: kNormalItemH)
        // 设置headerView的大小
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        // 2.创建collectionview
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        // 跟随父控件的fram
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        // 注册headerView
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        return collectionView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置UI界面
        setupUI()
    }

}

// MARK - 设置UI界面
extension RecommendViewController{
    fileprivate func setupUI(){
        
        // 1.添加到collectionView
        view.addSubview(collectionView)
    }
}

// MARK - 遵守UIcollectionDataSource
extension  RecommendViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return kSectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        var cell : UICollectionViewCell
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath)
        }
        
        // 2.设置内容
        
        
        return cell
    }
    
    // 设置headerView的内容
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1.取出section的headerView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID, for: indexPath)
        
        // 2.设置内容
       
        
        return headerView
    }
    
    // 重新设置item的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if indexPath.section == 1{
            return CGSize(width: kNormalItemW, height: kPrettyItemH)
        }
        return CGSize(width: kNormalItemW, height: kNormalItemH)
    }
}


// MARK - 遵守UICollectionViewDelegate
extension RecommendViewController : UICollectionViewDelegate{
    

    
}
