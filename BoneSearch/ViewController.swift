//
//  ViewController.swift
//  BoneSearch
//
//  Created by 俞旭涛 on 2017/12/1.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var text = ""
    var array = ["321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321","321321"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let button = UIButton(frame: CGRect(x: 10, y: 50, width: 100, height: 50))
        button.setTitle("搜索", for: UIControlState.normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(self.action), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func action() {
        let vc = BoneSearchController()
        vc.hotSearches = ["Java", "Python", "Objective-C", "Swift", "C", "C++", "PHP", "C#", "Perl", "Go", "JavaScript", "R", "Ruby", "Java", "Python", "Objective-C", "Swift"]
        vc.delegate = self
        vc.isHistorySearch = true
        vc.text = self.text
        vc.show(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: BoneSearchDelegate {
    
    
    
    func boneSearch(_ search: BoneSearchController, searchTextDidChange searchBar: BoneSearchBar, searchText: String) {
        self.text = searchText
    }
    
    func didClickCancel(_ search: BoneSearchController) {
        print("取消")
        search.dismiss()
    }
    
    func boneSearch(_ search: BoneSearchController, didSelect searchText: String) {
        print("didSelectHistories:\(searchText)")
        self.text = searchText
    }
    
    
    func boneSearch(_ search: BoneSearchController, didSelectHotSearchAt index: Int, searchText: String) {
        print("index:\(index)")
        print("didSelectHotSearchAt:\(searchText)")
        self.text = searchText
        search.reloadData()
    }
    
    func boneNumberOfResultRow(_ search: BoneSearchController) -> Int {
    
        return self.array.count
    }
    
    func boneSearch(_ search: BoneSearchController, resultTitleInRow row: Int) -> String? {
        return self.array[row]
    }
}


