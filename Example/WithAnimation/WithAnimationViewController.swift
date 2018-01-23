//
//  WithAnimationViewController.swift
//  SnapperDemo
//
//  Created by Yuma Matsune on 2018/01/20.
//  Copyright © 2018年 matsune. All rights reserved.
//

import Foundation
import SnapGestureRecognizer
import UIKit

final class WithAnimationViewController: UIViewController {

    private lazy var snapPointView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        v.backgroundColor = .gray
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 8.0
        return v
    }()
    
    private lazy var snapView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        v.backgroundColor = .orange
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 8.0
        return v
    }()
    
    let snapButton = UIButton(type: .system)
    
    var initialPoint: SnapPoint!
    var snapPoint: SnapPoint!
    
    let snapGesture = SnapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        snapButton.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        snapButton.setTitle("Snap!", for: .normal)
        snapButton.titleColor(for: .normal)
        snapButton.addTarget(self, action: #selector(WithAnimationViewController.didTapSnapButton(_:)), for: .touchUpInside)
        snapButton.center = CGPoint(x: view.center.x, y: view.bounds.height - 100)
        view.addSubview(snapButton)
        
        initialPoint = SnapPoint(CGPoint(x: view.center.x, y: 500),
                                 snapKey: "initialPoint")
        snapPoint = SnapPoint(CGPoint(x: view.center.x, y: 200),
                              snapKey: "snapPoint")
        
        snapView.center = initialPoint.cgPoint
        snapPointView.center = snapPoint.cgPoint
        view.addSubview(snapPointView)
        view.addSubview(snapView)
        
        snapGesture.snapPoints = [initialPoint, snapPoint]
        snapGesture.anchorPoint = .center
        snapGesture.snapTo = .direction
        snapGesture.snapDelegate = self
        
        snapView.addGestureRecognizer(snapGesture)
    }
    
    var isSnapPoint = false
    
    @objc
    func didTapSnapButton(_ sender: UIButton) {
        if isSnapPoint {
            snapGesture.snap(to: "initialPoint")
        } else {
            snapGesture.snap(to: "snapPoint")
        }
    }
}

extension WithAnimationViewController: SnapGestureRecognizerDelegate {
    
    func withSnapAnimation(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint) {
        if began.snapKey == "initialPoint" && toward.snapKey == "snapPoint" {
            snapGesture.view?.backgroundColor = .blue
            snapGesture.view?.frame.size = self.snapPointView.frame.size
        } else if began.snapKey == "snapPoint" && toward.snapKey == "initialPoint" {
            snapGesture.view?.backgroundColor = .orange
            snapGesture.view?.frame.size = CGSize(width: 60, height: 60)
        }
    }
    
    func snapRecognizerDidEndSnap(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint) {
        isSnapPoint = toward.snapKey == "snapPoint"
    }
}
