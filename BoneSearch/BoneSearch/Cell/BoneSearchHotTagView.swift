//
//  BoneSearchHotView.swift
//  BoneSearch
//
//  Created by 俞旭涛 on 2017/12/2.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

typealias BoneSearchTagOnClick = (_ index: Int, _ text: String) -> Void

class BoneSearchHotTagView: UIView {

    var hotDatas: [String]? {
        didSet {
            guard let datas = self.hotDatas else {
                return
            }
            guard datas.count > 0 else {
                self.frame.size.height = 0
                return
            }
            for view in self.subviews {
                if view.isKind(of: UILabel.self) {
                    view.removeFromSuperview()
                }
            }
            self.titleView = BoneSearchSectionView(title: "热门搜索", top: 0, width: self.frame.width)
            self.addSubview(self.titleView)
            
            let spacing: CGFloat = 10
            var left: CGFloat = 0
            var top: CGFloat = self.titleView.frame.height + self.titleView.frame.origin.y
            for i in 0..<datas.count {
                let label = labelWithTitle(datas[i])
                if (label.frame.width + left + spacing * 2) >= UIScreen.main.bounds.width {
                    top += spacing + label.frame.height
                    left = 0
                }
                
                label.frame.origin.x = left + spacing
                label.frame.origin.y = top + spacing
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tagDidCLick(gr:)))
                label.addGestureRecognizer(gesture)
                label.tag = i
                self.addSubview(label)
                
                left += spacing + label.frame.width
                
                if i == datas.count - 1 {
                    self.frame.size.height = label.frame.height + label.frame.origin.y + spacing
                }
            }
        }
    }
    
    var onClick: BoneSearchTagOnClick?
    
    private var titleView: BoneSearchSectionView!
    
    convenience init() {
        self.init(frame: CGRect.zero)

        self.frame.size.width = UIScreen.main.bounds.width
    }

    @objc fileprivate func tagDidCLick(gr: UITapGestureRecognizer) {
        guard let label = gr.view as? UILabel else {
            return
        }
        self.onClick?(label.tag, label.text ?? "")
    }
    
    fileprivate func labelWithTitle(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.layer.borderColor = nil
        label.layer.borderWidth = 0
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.gray
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        label.isUserInteractionEnabled = true
        label.sizeToFit()
        label.frame.size.height += 14
        label.frame.size.width += 20
        label.layer.cornerRadius = 3
        return label
    }
    
}
