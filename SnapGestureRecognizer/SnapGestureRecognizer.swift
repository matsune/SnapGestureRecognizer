//
//  SnapGestureRecognizer.swift
//  SnapGestureRecognizer
//
//  Created by Yuma Matsune on 2018/01/23.
//  Copyright © 2018年 matsune. All rights reserved.
//

open class SnapGestureRecognizer: UIPanGestureRecognizer {
    // - MARK: Animation
    open var duration: TimeInterval   = 0.4
    open var delay: TimeInterval      = 0.0
    open var dampingRatio: CGFloat    = 0.7
    open var springVelocity: CGFloat  = 0.0
    open var options: UIViewAnimationOptions = []
    
    // - MARK: Snap
    weak open var snapDelegate: SnapGestureRecognizerDelegate?
    open var panDirection: PanDirection   = .diagonal
    open var snapTo: SnapTo               = .direction
    open var snapPoints: [SnapPoint]      = []
    open private(set) var beganPoint: SnapPoint = .zero
    open var anchorPoint: SnapAnchor = .origin
    
    // - MARK: Initializer
    public init() {
        super.init(target: self, action: #selector(handlePan(recognizer:)))
    }
    
    public func snapPoint(for snapKey: String) -> SnapPoint? {
        return snapPoints.first(where: {$0.snapKey == snapKey})
    }
    
    public func snapPoint(at point: CGPoint) -> SnapPoint {
        if let p = snapPoints.first(where: {$0.cgPoint == point}) {
            return p
        } else {
            return SnapPoint(point)
        }
    }
    
    private var currentPoint: SnapPoint {
        guard let view = view else {
            fatalError()
        }
        
        switch anchorPoint {
        case .origin:
            return snapPoint(at: view.frame.origin)
        case .center:
            return snapPoint(at: view.center)
        }
    }
    
    // - MARK: Handler
    @objc
    private func handlePan(recognizer: UIPanGestureRecognizer) {
        guard let v = recognizer.view else {
            return
        }
        
        defer {
            recognizer.setTranslation(.zero, in: view)
        }
        
        let location = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        
        switch recognizer.state {
        case .began:
            beganPoint = currentPoint
            
            snapDelegate?.snapRecognizerWillBeginPan(self)
            
        case .changed:
            var draggingPoint = CGPoint(x: v.center.x + location.y,
                                        y: v.center.y + location.y)
            if anchorPoint == .origin {
                draggingPoint = draggingPoint - CGPoint(x: v.bounds.width / 2, y: v.bounds.height / 2)
            }
            let decay = snapDelegate?.snapRecognizer(self, decayAt: draggingPoint) ?? 0.0
            let accelerate = 1.0 - decay
            switch panDirection {
            case .diagonal:
                v.center = v.center + CGPoint(x: location.x * accelerate,
                                              y: location.y * accelerate)
            case .horizontal:
                v.center = v.center + CGPoint(x: location.x * accelerate,
                                              y: 0)
            case .vertical:
                v.center = v.center + CGPoint(x: 0,
                                              y: location.y * accelerate)
            }
            
            snapDelegate?.snapRecognizerDidPan(self)
            
        default:
            snapDelegate?.snapRecognizerDidEndPan(self)
            
            guard !snapPoints.isEmpty else {
                return
            }
            
            func findNearestPoint(_ current: CGPoint, from points: [CGPoint]) -> CGPoint {
                precondition(!points.isEmpty)
                
                var nearestPoint: CGPoint!
                var nearestDist: CGFloat!
                for p in points {
                    let dist = p.distance(from: current)
                    if nearestPoint == nil {
                        // first time
                        nearestDist = dist
                        nearestPoint = p
                        continue
                    }
                    if dist < nearestDist {
                        // update if distance is nearer
                        nearestDist = dist
                        nearestPoint = p
                    }
                }
                return nearestPoint
            }
            
            let current = currentPoint.cgPoint
            
            var towardPoint: CGPoint!
            switch snapTo {
            case .nearest:
                // find the nearest snap point by current from `snapPoints`
                towardPoint = findNearestPoint(current, from: snapPoints.map { $0.cgPoint })
            case .direction:
                var candidatePoints: [CGPoint] = []
                var tmpPoints: [CGPoint] = []
                if panDirection != .vertical {
                    let pannedLeft = velocity.x < 0
                    let pannedRight = velocity.x > 0
                    
                    if pannedLeft {
                        tmpPoints = snapPoints.filter { $0.x < current.x }.map { $0.cgPoint }
                    } else if pannedRight {
                        tmpPoints = snapPoints.filter { $0.x > current.x }.map { $0.cgPoint }
                    }
                }
                if !tmpPoints.isEmpty {
                    candidatePoints.append(findNearestPoint(current, from: tmpPoints))
                }
                
                tmpPoints = []
                if panDirection != .horizontal {
                    let pannedUp = velocity.y < 0
                    let pannedDown = velocity.y > 0
                    
                    if pannedUp {
                        tmpPoints = snapPoints.filter { $0.y < current.y }.map { $0.cgPoint }
                    } else if pannedDown {
                        tmpPoints = snapPoints.filter { $0.y > current.y }.map { $0.cgPoint }
                    }
                }
                if !tmpPoints.isEmpty {
                    candidatePoints.append(findNearestPoint(current, from: tmpPoints))
                }
                
                if candidatePoints.isEmpty {
                    towardPoint = beganPoint.cgPoint
                } else {
                    towardPoint = findNearestPoint(current, from: candidatePoints)
                }
            case .custom:
                towardPoint = snapDelegate?.snapRecognizer(self, towardSnapPointAt: current)
            }
            
            snap(to: snapPoint(at: towardPoint))
        }
    }
    
    // - MARK: public snap methods
    public func snap(to point: SnapPoint) {
        guard let view = view else {
            return
        }
        
        snapDelegate?.snapRecognizerWillBeginSnap(self, began: beganPoint, toward: point)
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: dampingRatio,
                       initialSpringVelocity: springVelocity,
                       options: options,
                       animations: {
                        self.snapDelegate?
                            .withSnapAnimation(self, began: self.beganPoint, toward: point)
                        switch self.anchorPoint {
                        case .origin:
                            view.frame.origin = point.cgPoint
                        case .center:
                            view.center = point.cgPoint
                        }
                        
        }, completion: { _ in
            self.snapDelegate?
                .snapRecognizerDidEndSnap(self, began: self.beganPoint, toward: point)
            self.beganPoint = point
        })
    }
    
    /// snap programatically
    /// - parameter point: CGPoint
    public func snap(to point: CGPoint) {
        beganPoint = currentPoint
        snap(to: snapPoint(at: point))
    }
    
    /// snap programatically
    /// - parameter snapKey: String
    public func snap(to snapKey: String) {
        if let point = snapPoint(for: snapKey) {
            beganPoint = currentPoint
            snap(to: point)
        } else {
            print("\(snapKey) is not registered.")
        }
    }
}
