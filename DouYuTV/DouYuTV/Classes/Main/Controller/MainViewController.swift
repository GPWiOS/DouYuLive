//
//  MainViewController.swift
//  DouYuTV
//
//  Created by GaiPengwei on 2017/4/24.
//  Copyright © 2017年 GaiPengwei. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVC("Home")
        addChildVC("Live")
        addChildVC("Follow")
        addChildVC("Profile")
        
    }

    
    fileprivate func addChildVC(_ storyName: String){
        
        // 1.通过storyBoard获取控制器
        let childVC = UIStoryboard.init(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        // 2.将childVC作为子控制器
        addChildViewController(childVC);
    }
    
}
