//
//  CGPointExtension.swift
//  Snapper
//
//  Created by Yuma Matsune on 2018/01/20.
//  Copyright © 2018年 matsune. All rights reserved.
//

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

extension CGPoint {
    func distance(from: CGPoint) -> CGFloat {
        let diff = self - from
        return sqrt(diff.x * diff.x + diff.y * diff.y)
    }
}
