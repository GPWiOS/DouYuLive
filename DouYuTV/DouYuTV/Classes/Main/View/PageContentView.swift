//
//  PageContentView.swift
//  DouYuTV
//
//  Created by GaiPengwei on 2017/5/10.
//  Copyright © 2017年 GaiPengwei. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(_ pageContentView : PageContentView, progress : CGFloat, startIndex : Int, endIndex : Int)
}

fileprivate let CollectionCellID = "CollectionCellID"
class PageContentView: UIView {
    
    // MARK - 定义属性
    fileprivate var childVCs : [UIViewController]
    fileprivate weak var parentVC : UIViewController?
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var isForbidScrollDelegate = false
    weak var delegate : PageContentViewDelegate?
    
    // MARK - 懒加载
    fileprivate lazy var collectionView : UICollectionView = { [weak self] in
        // 1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        // 2.创建collectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CollectionCellID)
        return collectionView
    }()
    
    // MARK - 自定义构造函数
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController?) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        // 设置contentView
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK - 设置contentView的UI
extension PageContentView {
    fileprivate func setupUI(){
        // 1.将所有的子控制器添加父控制器中
        for childVC in childVCs{
            parentVC?.addChildViewController(childVC)
        }
        
        // 2.添加UICollectionView，用于cell存放控制器的view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

// MARK - 遵守UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellID, for: indexPath)
        
        // 2.设置cell内容
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let childVC = childVCs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}

// MARK - 遵守UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0.判断是否是点击事件
        if  isForbidScrollDelegate { return }
        
        // 1.定义变量
        var progress : CGFloat = 0
        var startIndex : Int = 0
        var endIndex :Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX{ // 左滑
            // 2.1 计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            startIndex = Int(currentOffsetX / scrollViewW)
            endIndex = startIndex + 1
            if endIndex >= childVCs.count {
                endIndex = childVCs.count - 1
            }

            // 2.2.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                endIndex = startIndex
            }
            
        } else { // 右滑
            // 2.1 计算右滑 progress 
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            endIndex = Int(currentOffsetX / scrollViewW)
            startIndex = endIndex + 1
            if startIndex >= childVCs.count {
                startIndex = childVCs.count - 1
            }
        }
        
//        print("progress:\(progress) startIndex:\(startIndex)  endIndex:\(endIndex)")
        delegate?.pageContentView(self, progress: progress, startIndex: startIndex, endIndex: endIndex)
    }
}

// MARK - 供给外部使用的方法
extension PageContentView{
    func setupCurrentViewWithIndex(currentIndex : Int){
        // 1.记录需要进制执行代理方法
        isForbidScrollDelegate = true
        
        // 2.滚动正确的位置
        let offX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offX, y: 0), animated: false)
        
    }
}



