//
//  BoneSearchSource.swift
//  BoneSearch
//
//  Created by 俞旭涛 on 2017/12/1.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneSearchSource {

    
    /// 显示热门搜索
    var showHotSearch: Bool {
        get { return !self.hotSearches.isEmpty }
    }
    
    /// 是否有搜索页面，如果热门搜索和历史关键词都为0，则一直显示搜索页面
    var isResults: Bool {
        get { return !self.showHotSearch && !self.showHistorySearch }
    }
    
    /// 热门搜索
    var hotSearches = [String]()
    
    /// 显示历史搜索
    var showHistorySearch = true
    
    /// 是否显示搜索结果
    var showResultsSearch = false
    
    /// 搜索历史记录，默认20条
    var searchHistorieCount = 20
    
    /// 是否删除搜索字符串的空格，默认为“是”
    var removeSpaceOnSearchString = true
    
    
    /// 历史搜索
    var historiesSearches: NSMutableArray {
        get {
            return self.currentHistorieSearchs
        }
        set {
            self.currentHistorieSearchs = newValue
            self.saveHistoryCache()
        }
    }
    
    /// 历史标题
    func historiesTitle(_ indexPath: IndexPath) -> String? {
        return self.historiesSearches[indexPath.row] as? String
    }
    
    /// 更新历史缓存
    func updataHistoryCache(_ searchText: String) {
        var searchText = searchText
        // 去除空格
        if self.removeSpaceOnSearchString {
            searchText = String(searchText.filter { $0 != " " })
        }
        if self.showHistorySearch && searchText.count > 0 {
            self.currentHistorieSearchs.remove(searchText)
            self.currentHistorieSearchs.insert(searchText, at: 0)
            // 如果历史记录大于默认条数，删除最后一条
            if  self.currentHistorieSearchs.count > self.searchHistorieCount {
                self.currentHistorieSearchs.removeLastObject()
            }
            self.saveHistoryCache()
        }
    }
    
    /// 删除历史缓存
    func removeHistoryCache(_ indexPath: IndexPath) {
        var searchText: String = (self.currentHistorieSearchs[indexPath.row] as? String) ?? ""
        // 去除空格
        if self.removeSpaceOnSearchString {
            searchText = String(searchText.filter { $0 != " " })
        }
        if self.showHistorySearch && searchText.count > 0 {
            self.currentHistorieSearchs.remove(searchText)
        }
        self.saveHistoryCache()
    }
    
    /// 保存历史缓存
    func saveHistoryCache() {
        NSKeyedArchiver.archiveRootObject(self.currentHistorieSearchs, toFile: self.historieCachePath)
    }
    
    /// 清空历史缓存
    func cleanHistoryCache() {
        self.currentHistorieSearchs.removeAllObjects()
        self.saveHistoryCache()
    }
    
    /// 缓存文件名
    var cacheFileName = "" {
        didSet {
            if let array = NSKeyedUnarchiver.unarchiveObject(withFile: self.historieCachePath) as? NSArray {
                self.currentHistorieSearchs = NSMutableArray(array: array)
            } 
        }
    }
    
    var placeholder = "搜索内容"
    
    var searchText = ""

    /// 当前历史搜索
    fileprivate var currentHistorieSearchs: NSMutableArray!

    /// 搜索历史缓存路径
    fileprivate var historieCachePath: String {
        get {
            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first ?? ""
            return path.appendingFormat("/bone_search_%@.plist", self.cacheFileName)
        }
    }
    
    init() {
        if self.currentHistorieSearchs == nil {
            if let array = NSKeyedUnarchiver.unarchiveObject(withFile: self.historieCachePath) as? NSArray {
                self.currentHistorieSearchs = NSMutableArray(array: array)
            } else {
                self.currentHistorieSearchs = NSMutableArray()
            }
        }
    }
    
}
