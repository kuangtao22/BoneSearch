//
//  BoneSearchVC.swift
//  ChuanbeiBig
//
//  Created by 俞旭涛 on 2017/12/29.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneSearchVC: UISearchController {

    var update: Bool? {
        didSet {
            self.updateUI()
        }
    }
    
    var searchView: BoneSearchBar!
    var cleanOnClick: (() -> Void)?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isActive = true
    }
    
    init(_ searchResultsController: UIViewController!, searchFrame: CGRect) {
        super.init(searchResultsController: searchResultsController)
        self.searchBar.frame = searchFrame
        self.searchBar.showsBookmarkButton = false
        self.searchBar.showsCancelButton = true
        self.searchView = BoneSearchBar(frame: searchFrame)
        self.searchView.showsBookmarkButton = false
        self.searchView.showsCancelButton = true
    }
    
    func updateUI() {
        // 获取搜索栏子视图中搜索输入框的下标
        guard let subviews = self.searchBar.subviews.first?.subviews else {
            return
        }
 
        let button = subviews.flatMap { $0 as? UIButton }.first
        let buttonLeft = self.searchBar.frame.width - (button?.frame.width ?? 0)

        let textHeight = self.searchBar.frame.size.height - 24
        let textSize = CGSize(width: buttonLeft - textHeight - 20, height: textHeight)
        let textField = subviews.flatMap { $0 as? UITextField }.first
        textField?.frame = CGRect(origin: CGPoint(x: 15, y: 0), size: textSize)
        textField?.center.y = self.searchBar.center.y
        textField?.font = UIFont.systemFont(ofSize: 14)
        textField?.textColor = UIColor.gray
        textField?.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        textField?.layer.borderWidth = 1 / UIScreen.main.scale
        textField?.layer.cornerRadius = (textField?.frame.height ?? 0) / 2
        textField?.layer.masksToBounds = true
        // 设置背景颜色
        textField?.backgroundColor = UIColor.white

        if let frame = textField?.frame {
            let cleanButton = UIButton(frame: CGRect(x: frame.width + frame.origin.x, y: frame.minY, width: frame.height, height: frame.height))
            cleanButton.setImage(UIImage(named: "BoneSearch.bundle/clean"), for: UIControlState.normal)
//            cleanButton.setTitle("清除搜索内容", for: UIControlState.normal)
            cleanButton.addTarget(self, action: #selector(self.cleanAction), for: UIControlEvents.touchUpInside)
            self.searchBar.addSubview(cleanButton)
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 清理事件
    @objc private func cleanAction() {
        self.searchBar.text = ""
        self.cleanOnClick?()
    }
}

