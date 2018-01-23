//
//  SnapPoint.swift
//  Snapper
//
//  Created by Yuma Matsune on 2018/01/21.
//  Copyright © 2018年 matsune. All rights reserved.
//

public struct SnapPoint {
    public var x: CGFloat
    public var y: CGFloat
    public var snapKey: String?
    
    public init(x: CGFloat, y: CGFloat, snapKey: String? = nil) {
        self.x = x
        self.y = y
        self.snapKey = snapKey
    }
    
    public init(_ point: CGPoint, snapKey: String? = nil) {
        self.init(x: point.x, y: point.y, snapKey: snapKey)
    }
    
    public static let zero = SnapPoint(x: 0, y: 0)
    
    public var cgPoint: CGPoint {
        return CGPoint(x: x, y: y)
    }
}
