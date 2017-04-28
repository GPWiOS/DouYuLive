//
//  PageTitleView.swift
//  DouYuTV
//
//  Created by GaiPengwei on 2017/4/29.
//  Copyright © 2017年 GaiPengwei. All rights reserved.
//

import UIKit

// MARK:- 定义常量
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {
    
    // MARK - 定义属性
    fileprivate var titles : [String]
    
    fileprivate var titleLabels : [UILabel] = [UILabel]()
    fileprivate var scrollView : UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.scrollsToTop = false
        
        return scrollView
    }()
    fileprivate var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
        
    }()
    
    // MARK - 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        
        self.titles = titles
        super.init(frame: frame)
        
        // 设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageTitleView{
    
    fileprivate func setupUI(){
        
        // 1.添加scrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2.添加title对应的Label
        setupTitleLabels()
        
        // 3. 添加
        setupBottomLineAndScrollLine()
        
    }
    
    fileprivate func setupTitleLabels(){
        
        // Label的一些设置
        let labelY : CGFloat = 0
        let labelW : CGFloat = frame.width / CGFloat(self.titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        
        for (index, title) in titles.enumerated() {
            // 1.创建Label
            let label = UILabel()
            
            // 2.设置Label属性
            label.text = title
            label.tag = index
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.boldSystemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            
            // 3.设置frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4.添加到scrollView中
            scrollView.addSubview(label)
            titleLabels.append(label)
            
        }
        
    }
    
    fileprivate func setupBottomLineAndScrollLine(){
        
        // 1.创建底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        
        addSubview(bottomLine)
        
        // 2.添加scrollLine
        // 2.1.获取第一个Label
        guard let firstLabel = titleLabels.last else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        
        // 2.2.设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        guard let labelText = firstLabel.text else { return }
        let labelSize = labelText.size(attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16)])
        let labelX = firstLabel.frame.origin.x + (firstLabel.frame.width - labelSize.width) / 2
        //        scrollLine.center = CGRect(origin: CGPoint, size: <#T##CGSize#>)
        scrollLine.frame = CGRect(x: labelX, y: frame.height - kScrollLineH, width: labelSize.width, height: kScrollLineH)
        
    }
    
}
