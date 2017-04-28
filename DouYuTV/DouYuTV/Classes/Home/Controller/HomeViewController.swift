//
//  HomeViewController.swift
//  DouYuTV
//
//  Created by GaiPengwei on 2017/4/24.
//  Copyright © 2017年 GaiPengwei. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

    
    // MARK - 懒加载
    fileprivate lazy var pageTitleView : PageTitleView = {[weak self] in
       
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleFrame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kTitleViewH)
        let titleView = PageTitleView.init(frame: titleFrame, titles: titles)
//        titleView.backgroundColor = UIColor.blue
        return titleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.设置界面UI
        setupUI()
    }

    
}

// MARK - 设置UI
extension HomeViewController{
    /**
     设置首页UI
     */
    fileprivate func setupUI(){
        // 0.取消内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 1.设置导航栏
        setupNavigationBar()
        
        // 2.添加TitleView
        view.addSubview(pageTitleView)

    }
    
    fileprivate func setupNavigationBar(){
        // 1.设置左侧Item
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "logo")
        
        // 2.设置右侧Item
        let size = CGSize(width: 40, height: 40)
        let searchItem = UIBarButtonItem.init(imageName: "btn_search", highImageName: "btn_search_click", size: size)
        let sacnItem = UIBarButtonItem.init(imageName: "btn_scan", highImageName: "btn_scan_click", size: size)
        let historyItem = UIBarButtonItem.init(imageName: "btn_my_history", highImageName: "btn_my_history_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem, sacnItem, searchItem]
        
    }
    
}
