//
//  BoneSearchHistoriesCell.swift
//  BoneSearch
//
//  Created by 俞旭涛 on 2017/12/3.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneSearchHistoriesCell: UITableViewCell {
    
    private var closeButton: UIButton!
    
    var closeAction: (() -> ())?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.textLabel?.font = UIFont.systemFont(ofSize: 14)
        self.textLabel?.textColor = UIColor.gray
        self.backgroundColor = UIColor.clear
        
        self.imageView?.image = UIImage(named: "BoneSearch.bundle/search_history")
        self.closeButton = UIButton()
        self.closeButton.frame.size = CGSize(width: self.frame.height, height: self.frame.height)
        self.closeButton.setImage(UIImage(named: "BoneSearch.bundle/close"), for: UIControlState.normal)
        self.closeButton.contentMode = .center
        self.closeButton.addTarget(self, action: #selector(self.action(button:)), for: UIControlEvents.touchUpInside)
        self.accessoryView = self.closeButton
        
        let line = UIImageView(image: UIImage(named: "BoneSearch.bundle/cell-content-line"))
        line.alpha = 0.7
        line.frame.size = CGSize(width: self.frame.width, height: 0.5)
        line.frame.origin = CGPoint(x: 15, y: self.frame.height - 0.5)
        self.contentView.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func action(button: UIButton) {
        self.closeAction?()
    }
}
