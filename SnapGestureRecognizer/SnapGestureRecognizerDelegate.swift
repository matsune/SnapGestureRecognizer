//
//  SnapGestureRecognizerDelegate.swift
//  SnapGestureRecognizer
//
//  Created by Yuma Matsune on 2018/01/23.
//  Copyright © 2018年 matsune. All rights reserved.
//

public protocol SnapGestureRecognizerDelegate: class {
    func snapRecognizer(_ snapRecognizer: SnapGestureRecognizer, decayAt point: CGPoint) -> CGFloat
    func snapRecognizer(_ snapRecognizer: SnapGestureRecognizer, towardSnapPointAt point: CGPoint) -> CGPoint
    
    func snapRecognizerWillBeginPan(_ snapRecognizer: SnapGestureRecognizer)
    func snapRecognizerDidPan(_ snapRecognizer: SnapGestureRecognizer)
    func snapRecognizerDidEndPan(_ snapRecognizer: SnapGestureRecognizer)
    
    func snapRecognizerWillBeginSnap(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint)
    func snapRecognizerDidEndSnap(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint)
    
    func withSnapAnimation(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint)
}

public extension SnapGestureRecognizerDelegate {
    func snapRecognizer(_ snapRecognizer: SnapGestureRecognizer, decayAt point: CGPoint) -> CGFloat {
        return 0.0
    }
    
    func snapRecognizer(_ snapRecognizer: SnapGestureRecognizer, towardSnapPointAt point: CGPoint) -> CGPoint {
        fatalError("If you set `snapTo` to `.custom`, you must implement this method.")
    }
    
    func snapRecognizerWillBeginPan(_ snapRecognizer: SnapGestureRecognizer) {}
    
    func snapRecognizerDidPan(_ snapRecognizer: SnapGestureRecognizer) {}
    
    func snapRecognizerDidEndPan(_ snapRecognizer: SnapGestureRecognizer) {}
    
    func snapRecognizerWillBeginSnap(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint) {}
    
    func snapRecognizerDidEndSnap(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint) {}
    
    func withSnapAnimation(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint) {}
}

