//
//  BoneSearchController.swift
//  BoneSearch
//
//  Created by 俞旭涛 on 2017/12/1.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneSearchController: UIViewController {
    
    var tintColor: UIColor?
    
    
    /// 热门搜索
    var hotSearches: [String]? {
        didSet {
            guard let datas = self.hotSearches else {
                return
            }
            self.source.hotSearches = datas
            if self.source.showHotSearch {
                self.hotView.hotDatas = datas
            }
        }
    }

    /// 协议
    weak var delegate: BoneSearchDelegate?

    /// 是否打开历史记录
    var isHistorySearch: Bool? {
        didSet {
            guard let isHistorySearch = self.isHistorySearch else {
                return
            }
            self.source.showHistorySearch = isHistorySearch
        }
    }
    
    /// 搜索名称
    var text: String? {
        didSet {
            self.source.searchText = self.text ?? ""
        }
    }
    
    /// 缓存文件名称
    var cacheFileName: String? {
        didSet {
            self.source.cacheFileName = self.cacheFileName ?? ""
        }
    }
    
    var placeholder: String? {
        didSet {
            self.source.placeholder = self.placeholder ?? ""
        }
    }
    
    /// 最大历史记录条数
    var historieMax: Int? {
        didSet {
            self.source.searchHistorieCount = self.historieMax ?? 20
        }
    }

    fileprivate var statusBarStyle: UIStatusBarStyle = .default

    // 搜索控制器
    fileprivate var searchVC: BoneSearchVC!
    /// 历史/热门表格
    fileprivate var historiesTable: UITableView!
    /// 搜索结果表格
    fileprivate var resultsTable: UITableView!

    /// 键盘状态是否显示
    fileprivate var keyboardDidShow = true

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchVC.searchView.resignFirstResponder()
        UIApplication.shared.statusBarStyle = self.statusBarStyle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 显示键盘
        self.perform(#selector(self.showKeyboard), with:nil, afterDelay:0.1)
        self.statusBarStyle = UIApplication.shared.statusBarStyle
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboradFrameDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboradFrameDidHidden(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
                
        self.view.backgroundColor = UIColor.white
        self.source.showResultsSearch = self.source.isResults
        
        self.definesPresentationContext = true
        self.searchVC = BoneSearchVC(nil, searchFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 40))
        
        self.searchVC.searchView.placeholder = self.source.placeholder
        self.searchVC.searchView.delegate = self
        
        self.searchVC.searchView.text = self.source.searchText
        self.searchVC.definesPresentationContext = true
        self.searchVC.hidesNavigationBarDuringPresentation = false  // 不隐藏导航
        self.searchVC.dimsBackgroundDuringPresentation = false      // 不显示背景
        self.searchVC.searchView.sizeToFit()
        self.searchVC.searchView.tintColor = self.tintColor
        self.searchVC.searchView.cleanOnClick = {
            self.delegate?.boneSearch(self, didSelect: self.searchVC.searchView.text ?? "")
        }
        self.navigationItem.titleView = self.searchVC.searchView

        
        let navHeight = self.navigationController?.navigationBar.frame.maxY ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        
        self.historiesTable = UITableView(frame: self.view.bounds, style: .grouped)
        self.historiesTable.delegate = self
        self.historiesTable.dataSource = self
        self.historiesTable.separatorStyle = .none
        self.historiesTable.backgroundColor = UIColor.white
        self.view.addSubview(self.historiesTable)
        
        self.resultsTable = UITableView(frame: self.view.bounds, style: .grouped)
        self.resultsTable.frame.origin.y = navHeight + statusBarHeight
        self.resultsTable.delegate = self
        self.resultsTable.dataSource = self
        self.resultsTable.separatorStyle = .none
        self.resultsTable.backgroundColor = UIColor.white
        self.view.addSubview(self.resultsTable)
        
        if !self.source.hotSearches.isEmpty {
            self.historiesTable.tableHeaderView = self.hotView
        }
        self.updateResults()
    }
    
    /// 数据源
    fileprivate lazy var source: BoneSearchSource = {
        return BoneSearchSource()
    }()
    
    fileprivate lazy var historiesView: BoneSearchSectionView = {
        let view = BoneSearchSectionView(title: "搜索历史", top: 0, width: self.view.frame.width)
        view.cleanButton.isHidden = false
        view.cleanAction = {
            self.source.cleanHistoryCache()
            self.historiesTable.reloadData()
        }
        return view
    }()
    
    /// 热门
    fileprivate lazy var hotView: BoneSearchHotTagView = {
        let hotView = BoneSearchHotTagView()
        hotView.onClick = { (index, text) in
            self.source.updataHistoryCache(text)
            self.searchVC.searchView.text = text
            self.historiesTable.reloadData()
            self.delegate?.boneSearch(self, didSelectHotSearchAt: index, searchText: text)
        }
        return hotView
    }()
    
    /// 刷新
    func reloadData() {
        self.historiesTable.reloadData()
        self.resultsTable.reloadData()
    }
    
    /// 更新搜索结果
    fileprivate func updateResults() {
        self.resultsTable.isHidden = !self.source.showResultsSearch
        self.historiesTable.isHidden = self.source.showResultsSearch
        self.reloadData()
    }
    
    @objc private func keyboradFrameDidShow(notification: NSNotification) {
        self.keyboardDidShow = true
        let keyboardHeight = (notification.object as? UIView)?.frame.size.height ?? 0
        self.historiesTable.frame.size.height -= keyboardHeight
    }
    
    @objc private func keyboradFrameDidHidden(notification: NSNotification) {
        self.keyboardDidShow = false
        let keyboardHeight = (notification.object as? UIView)?.frame.size.height ?? 0
        self.historiesTable.frame.size.height += keyboardHeight
    }
    
    /// 显示键盘
    @objc fileprivate func showKeyboard() {
        self.searchVC.searchView.becomeFirstResponder()
    }
    
    func dismiss() {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.presentingViewController?.dismiss(animated: true) { }
            }
        }
    }
    
    func show(_ forView: UIViewController) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                let navVC = UINavigationController(rootViewController: self)
                forView.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension BoneSearchController: UISearchBarDelegate {
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("点击了语音按钮")
    }
    
    // 开始进行文本编辑，设置显示搜索结果，刷新列表
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchVC.searchView.text = searchBar.text
        if self.source.isResults {
            self.source.showResultsSearch = true
        } else {
            self.source.showResultsSearch = (searchBar.text?.count ?? 0) > 0
        }
        self.updateResults()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchVC.searchView.text = searchText
        if self.source.isResults {
            self.source.showResultsSearch = true
        } else {
            self.source.showResultsSearch = searchText.count > 0
        }
        self.delegate?.boneSearch(self, searchTextDidChange: self.searchVC.searchView, searchText: searchText)

        self.updateResults()
    }


    // 点击取消按钮
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.delegate?.didClickCancel(self)
    }
    
    // 搜索按钮被点击后
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        self.source.updataHistoryCache(searchText)
        self.historiesTable.reloadSections(IndexSet.init(integer: 0), with: .automatic)
        self.delegate?.boneSearch(self, didSelect: searchText)
    }

}

extension BoneSearchController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultsTable == tableView {
            return self.delegate?.boneNumberOfResultRow(self) ?? 0
        }
        return self.source.historiesSearches.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.resultsTable == tableView {
            return nil
        } else {
            if section == 0 && self.source.showHistorySearch {
                return self.historiesView
            }
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.resultsTable == tableView {
            return 0.01
        } else {
            if section == 0 && self.source.showHistorySearch {
                return 35
            }
            return 0.01
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "BoneSearchCell"
        if tableView == self.resultsTable {
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.textLabel?.textColor = UIColor.darkGray
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                cell?.backgroundColor = UIColor.clear
                let line = UIImageView(image: UIImage(named: "BoneSearch.bundle/cell-content-line"))
                line.frame.size.height = 0.5
                line.alpha = 0.7
                line.frame.origin.x = 10
                line.frame.origin.y = 43
                line.frame.size.width = UIScreen.main.bounds.width - line.frame.origin.x
                cell?.contentView.addSubview(line)
            }
            cell?.textLabel?.text = self.delegate?.boneSearch(self, resultTitleInRow: indexPath.row)
            cell?.imageView?.image = UIImage(named: "BoneSearch.bundle/search")
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BoneSearchHistoriesCell
            if cell == nil {
                cell = BoneSearchHistoriesCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
            }
            cell?.textLabel?.text = self.source.historiesTitle(indexPath)
            cell?.closeAction = {
                self.source.removeHistoryCache(indexPath)
                self.historiesTable.reloadData()
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchVC.searchView.resignFirstResponder()
        if self.resultsTable == tableView {
            self.delegate?.boneSearch(self, didSelectResultSearchAt: indexPath)
        } else {
            let searchText = self.source.historiesTitle(indexPath) ?? ""
            self.searchVC.searchView.text = searchText
            self.source.updataHistoryCache(searchText)
            self.historiesTable.reloadData()
            self.delegate?.boneSearch(self, didSelect: searchText)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchVC.searchView.resignFirstResponder()
    }
}


