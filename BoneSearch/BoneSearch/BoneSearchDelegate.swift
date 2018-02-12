//
//  BoneSearchDelegate.swift
//  BoneSearch
//
//  Created by 俞旭涛 on 2017/12/1.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

protocol BoneSearchDelegate: NSObjectProtocol {
    
    /// 当搜索内容改变
    func boneSearch(_ search: BoneSearchController, searchTextDidChange searchBar: BoneSearchBar, searchText: String)
    
    /// 取消搜索
    func didClickCancel(_ search: BoneSearchController)
    
    /// 点击搜索
    func boneSearch(_ search: BoneSearchController, didSelect searchText: String)
    
    /// 点击热门搜索
    func boneSearch(_ search: BoneSearchController, didSelectHotSearchAt index: Int, searchText: String)
    
    /// 搜索结果行数
    func boneNumberOfResultRow(_ search: BoneSearchController) -> Int
    
    /// 搜索结果标题
    func boneSearch(_ search: BoneSearchController, resultTitleInRow row: Int) -> String
    
    /// 搜索结果点击事件
    func boneSearch(_ search: BoneSearchController, didSelectResultSearchAt indexPath: IndexPath)
}

extension BoneSearchDelegate {
    
    func boneSearch(_ search: BoneSearchController, searchTextDidChange searchBar: BoneSearchBar, searchText: String) {
        
    }
    
    func didClickCancel(_ search: BoneSearchController) {
        search.dismiss()
    }
    
    func boneSearch(_ search: BoneSearchController, didSelectHotSearchAt index: Int, searchText: String) {
        search.dismiss()
    }
    
    func boneNumberOfResultRow(_ search: BoneSearchController) -> Int {
        return 0
    }
    
    func boneSearch(_ search: BoneSearchController, resultTitleInRow row: Int) -> String {
        return ""
    }
    
    func boneSearch(_ search: BoneSearchController, didSelectResultSearchAt indexPath: IndexPath) {
        search.dismiss()
    }
}
