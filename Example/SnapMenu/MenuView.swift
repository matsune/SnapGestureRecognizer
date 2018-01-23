//
//  MenuView.swift
//  SnapperDemo
//
//  Created by Yuma Matsune on 2018/01/23.
//  Copyright © 2018年 matsune. All rights reserved.
//

import Foundation
import UIKit

final class MenuView: UIView {
    
    let tableView = UITableView()
    let footerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        
        footerView.backgroundColor = .lightGray
        addSubview(footerView)
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 100))
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "MenuHeaderCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        footerView.frame = CGRect(x: 0, y: bounds.height/2, width: bounds.width, height: bounds.height/2)
        tableView.frame = bounds
        tableView.backgroundColor = .clear
        
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5
    }
}
