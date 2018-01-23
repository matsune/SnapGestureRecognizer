//
//  MenuHeaderCell.swift
//  SnapperDemo
//
//  Created by Yuma Matsune on 2018/01/22.
//  Copyright © 2018年 matsune. All rights reserved.
//

import Foundation
import UIKit

final class MenuHeaderCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = 8.0
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
