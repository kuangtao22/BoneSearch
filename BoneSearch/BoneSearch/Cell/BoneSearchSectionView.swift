//
//  BoneSearchSectionView.swift
//  BoneSearch
//
//  Created by 俞旭涛 on 2017/12/3.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneSearchSectionView: UIView {

    var titleLabel: UILabel!
    var cleanButton: UIButton!
    
    var cleanAction: (() -> Void)?
    
    convenience init(title: String, top: CGFloat, width: CGFloat) {
        self.init(frame: CGRect(x: 0, y: top, width: width, height: 35))
        
        self.titleLabel = UILabel(frame: CGRect(x: 15, y: 15, width: self.frame.width - 20, height: self.frame.height - 15))
        self.titleLabel.text = title
        self.titleLabel.font = UIFont.systemFont(ofSize: 13)
        self.titleLabel.textColor = UIColor.gray
        self.addSubview(self.titleLabel)
        
        self.cleanButton = UIButton()
        self.cleanButton.setTitle("清空", for: UIControlState.normal)
        self.cleanButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.cleanButton.setTitleColor(self.titleLabel.textColor, for: UIControlState.normal)
        self.cleanButton.setImage(UIImage(named: "BoneSearch.bundle/empty"), for: UIControlState.normal)
        self.cleanButton.sizeToFit()
        self.cleanButton.frame.size.height = self.titleLabel.frame.height
        self.cleanButton.center.y = self.titleLabel.center.y
        self.cleanButton.center.x = self.frame.width - self.cleanButton.frame.width - 15
        self.cleanButton.addTarget(self, action: #selector(self.action(button:)), for: UIControlEvents.touchUpInside)
        self.addSubview(self.cleanButton)
    }

    @objc private func action(button: UIButton) {
        self.cleanAction?()
    }
}
