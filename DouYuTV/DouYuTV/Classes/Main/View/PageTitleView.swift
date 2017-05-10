//
//  PageTitleView.swift
//  DouYuTV
//
//  Created by GaiPengwei on 2017/4/29.
//  Copyright © 2017年 GaiPengwei. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate :class {
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int)
}


// MARK:- 定义常量
private let kScrollLineH : CGFloat = 3
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)
private let kTitileLineSpace : CGFloat = 20

class PageTitleView: UIView {
    
    // MARK - 定义属性
    fileprivate var titles : [String]
    fileprivate var currentIndex : Int = 0
    weak var delegate : PageTitleViewDelegate?
    
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
            
            // 5.给Label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            
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
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        // 2.2.设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        
        /*
        // 计算label内容的宽度
        guard let labelText = firstLabel.text else { return }
        let labelSize = labelText.size(attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16)])
        let labelX = firstLabel.frame.origin.x + (firstLabel.frame.width - labelSize.width) / 2
        //        scrollLine.center = CGRect(origin: CGPoint, size: <#T##CGSize#>)
        */
        let lineW = firstLabel.frame.width - 2 * kTitileLineSpace
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x + kTitileLineSpace, y: frame.height - kScrollLineH, width: lineW, height: kScrollLineH)
        
    }
    
}



// MARK - 监听label点击
extension PageTitleView {
    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer){
//        print(tapGes.view?.tag)
        
        // 1、获取被点击的label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        // 1.1 若重复点击同一个title，直接返回
        if currentLabel.tag == currentIndex { return }
        
        // 2. 获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        // 3.切换文字的颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        // 4.保存最新的currentIndex
        currentIndex = currentLabel.tag
        
        // 5.底线跟随移动
        let offX = CGFloat(currentIndex) * currentLabel.frame.width + kTitileLineSpace
        UIView.animate(withDuration: 0.10) {
            self.scrollLine.frame.origin.x = offX
        }
        
        // 6.通知代理
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
        
    }
}

// MARK - 共外部调用的方法
extension PageTitleView{
    
    func setTitleWithProgress(_ progress : CGFloat, startIndex : Int, endIndex : Int){
        
        // 1.取出startLabel/endLabel
        let startLabel = titleLabels[startIndex]
        let endLabel = titleLabels[endIndex]
        
        // 2.处理滑块的逻辑
        let moveTotalX = endLabel.frame.origin.x - startLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = startLabel.frame.origin.x + kTitileLineSpace + moveX
        
        // 3.文字颜色渐变(复杂)
        // 3.1取出颜色变化范围
        let colorRange = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        // 3.2颜色变化
        startLabel.textColor = UIColor(r: kSelectColor.0 - colorRange.0 * progress, g: kSelectColor.1 - colorRange.1 * progress, b: kSelectColor.2 - colorRange.2 * progress)
        
        endLabel.textColor = UIColor(r: kNormalColor.0 + colorRange.0 * progress, g: kNormalColor.1 + colorRange.1 * progress, b: kSelectColor.2 + colorRange.2 * progress)
        // 4.记录最新的index
        currentIndex = endIndex
    }
    
    
}

