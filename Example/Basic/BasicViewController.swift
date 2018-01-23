//
//  BasicViewController.swift
//  SnapperDemo
//
//  Created by Yuma Matsune on 2018/01/20.
//  Copyright © 2018年 matsune. All rights reserved.
//

import UIKit
import SnapGestureRecognizer

final class BasicViewController: UIViewController {

    let snapView = UIView(frame: .zero)
    var initPosition: CGPoint!
    
    let snapGesture = SnapGestureRecognizer()
    var decay: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        snapView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        snapView.layer.masksToBounds = true
        snapView.layer.cornerRadius = 8.0
        snapView.center = CGPoint(x: view.center.x, y: 255)
        initPosition = snapView.center
        snapView.backgroundColor = .orange
        view.insertSubview(snapView, at: 0)
        
        let snapPoints = [
            SnapPoint(x: 50, y: 150),
            SnapPoint(x: view.bounds.width - 50, y: 150),
            SnapPoint(x: 50, y: 360),
            SnapPoint(x: view.bounds.width - 50, y: 360)
        ]
        for i in 0..<4 {
            let v = createSnapPointView(center: snapPoints[i])
            view.insertSubview(v, at: 0)
        }
        
        snapGesture.anchorPoint = .center
        snapGesture.snapPoints = snapPoints
        snapGesture.snapDelegate = self
        snapView.addGestureRecognizer(snapGesture)
        
        bindSetting()
    }

    
    private func createSnapPointView(center: SnapPoint) -> UIView {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        v.backgroundColor = .gray
        v.center = center.cgPoint
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 8.0
        return v
    }
    
    private func bindSetting() {
        guard let settingVC = childViewControllers.first(where: {$0 is BasicConfigTableViewController}) as? BasicConfigTableViewController else {
            return
        }
        settingVC.onChangeSnapTo = { row in
            self.snapGesture.snapTo = [SnapTo.direction, SnapTo.nearest, SnapTo.custom][row]
        }
        settingVC.onChangePanDirection = { row in
            self.snapGesture.panDirection = [PanDirection.diagonal, PanDirection.horizontal, PanDirection.vertical][row]
        }
        settingVC.onChangeDecay = { value in
            self.decay = CGFloat(value)
        }
        settingVC.onChangeDuration = { value in
            self.snapGesture.duration = TimeInterval(value)
        }
        settingVC.onChangeDelay = { value in
            self.snapGesture.delay = TimeInterval(value)
        }
        settingVC.onChangeSpring = { value in
            self.snapGesture.springVelocity = CGFloat(value)
        }
        settingVC.onChangeDamping = { value in
            self.snapGesture.dampingRatio = CGFloat(value)
        }
    }
}

extension BasicViewController: SnapGestureRecognizerDelegate {
    
    func snapRecognizer(_ snapRecognizer: SnapGestureRecognizer, decayAt point: CGPoint) -> CGFloat {
        return decay
    }
    
    func snapRecognizer(_ snapRecognizer: SnapGestureRecognizer, towardSnapPointAt point: CGPoint) -> CGPoint {
        // In this case, always snap to initial position when `snapTo` is `.custom`.
        return initPosition
    }
    
    func snapRecognizerWillBeginPan(_ snapRecognizer: SnapGestureRecognizer) {
        print("willBeginPan")
    }
    
    func snapRecognizerDidPan(_ snapRecognizer: SnapGestureRecognizer) {
        print("didPan")
    }
    
    func snapRecognizerDidEndPan(_ snapRecognizer: SnapGestureRecognizer) {
        print("DidEndPan")
    }
    
    func snapRecognizerWillBeginSnap(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint) {
        print("willBeginSnap")
    }
    
    func snapRecognizerDidEndSnap(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint) {
        print("didEndSnap")
    }
}
