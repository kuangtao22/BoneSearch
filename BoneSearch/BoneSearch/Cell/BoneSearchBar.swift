//
//  BoneSearchBar.swift
//  ChuanbeiBig
//
//  Created by 俞旭涛 on 2017/12/29.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneSearchBar: UISearchBar {

    /// 字体大小
    var font: UIFont = UIFont.systemFont(ofSize: 14)
    
    /// 字体颜色
    var textColor: UIColor = UIColor.gray
    
    var cleanOnClick: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
//        self.barStyle = .default
//        self.searchBarStyle = .prominent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {

        // 获取搜索栏子视图中搜索输入框的下标
        guard let subviews = self.subviews.first?.subviews else {
            return
        }
        
        let button = subviews.flatMap { $0 as? UIButton }.first
        let buttonLeft = button?.frame.origin.x ?? 0

        let textHeight: CGFloat = 30
        var textLeft: CGFloat = 0
        if #available(iOS 10, *) {
            textLeft = 15
        }
        let textSize = CGSize(width: buttonLeft - textHeight - 20, height: textHeight)
        let textField = subviews.flatMap { $0 as? UITextField }.first
        textField?.frame = CGRect(origin: CGPoint(x: textLeft, y: 0), size: textSize)
        textField?.center.y = self.center.y
        textField?.font = self.font
        textField?.textColor = self.textColor
        textField?.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        textField?.layer.borderWidth = 1 / UIScreen.main.scale
        textField?.layer.cornerRadius = (textField?.frame.height ?? 0) / 2
        textField?.layer.masksToBounds = true
        // 设置背景颜色
        textField?.backgroundColor = UIColor.white
        

        if let frame = textField?.frame {
            let cleanButton = UIButton(frame: CGRect(x: frame.maxX, y: frame.minY, width: frame.height, height: frame.height))
            cleanButton.setImage(UIImage(named: "BoneSearch.bundle/clean"), for: UIControlState.normal)
            cleanButton.addTarget(self, action: #selector(self.cleanAction), for: UIControlEvents.touchUpInside)
            self.addSubview(cleanButton)
        }
        super.draw(rect)
    }
    
    /// 清理事件
    @objc private func cleanAction() {
        self.text = ""
        self.cleanOnClick?()
    }
}
