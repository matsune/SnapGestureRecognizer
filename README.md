# SnapGestureRecognizer
SnapGestureRecognizer provides dynamic pan and snap interaction for UIVIew objects.

<p align="center">
<img src="https://raw.githubusercontent.com/matsune/SnapGestureRecognizer/master/Assets/demo1.gif" width="200">
</p>

# Installation
### Carthage
`github "matsune/SnapGestureRecognizer`

# Usage
SnapGestureRecognizer is a subclass of `UIPanGestureRecognizer`. You can use by `addGestureRecognizer` for any UIView instance.
```swift
let snapGesture = SnapGestureRecognizer()

let view = UIView()
view.addGestureRecognizer(snapGesture)
```

## Properties
### Snap Properties
SnapGestureRecognizer has these configurable snap properties.
```swift
var panDirection: PanDirection
var snapTo:       SnapTo
var snapPoints:   [SnapPoint]
var anchorPoint:  SnapAnchor
```

#### PanDirection
```swift
enum PanDirection {
    case diagonal
    case horizontal
    case vertical
}
```
This property allows object direction to move by user's pan gesture.
If set `.horizontal`, object moves along horizontal direction. 

#### SnapTo
```swift
enum SnapTo {
  case .direction
  case .nearest
}
```
This property is used to determine snap point at the moment that user released object.

|.direction|.nearest|
|:-:|:-:|
|<img src="https://raw.githubusercontent.com/matsune/SnapGestureRecognizer/master/Assets/direction.gif" width="200">|<img src="https://raw.githubusercontent.com/matsune/SnapGestureRecognizer/master/Assets/nearest.gif" width="200">|
|find the nearest snap point towards swiped direction|find the nearest snap point from current object position|

#### SnapPoint & SnapAnchor
```swift
enum SnapAnchor {
    case origin
    case center
}

let snapPoints = [
  SnapPoint(x: view.center.x, y: 100),
  SnapPoint(x: view.center.x, y: 300, snapKey: "pointA") // you can set key to point
]
snapGesture.anchorPoint = .center
snapGesture.snapPoints  = snapPoints
```

### Animation Properties
You can configure snap animation properties.
```swift
var duration:       TimeInterval
var delay:          TimeInterval
var dampingRatio:   CGFloat
var springVelocity: CGFloat
var options:        UIViewAnimationOptions
```

### Programatically Methods
There are some methods to snap object programatically.
```swift
func snap(to point: SnapPoint)
func snap(to point: CGPoint)
func snap(to snapKey: String)
```
If you have set snapKey for snap point, you can specify the point by the key name.
```swift
let snapPoints = [
  SnapPoint(x: 100, y: 100, snapKey: "pointA")
]
snapGesture.snapPoints  = snapPoints
snapGesture.snap(to: "pointA")
```

### Delegate
```swift
protocol SnapGestureRecognizerDelegate: class {
  func snapRecognizer(_ snapRecognizer: SnapGestureRecognizer, decayAt point: CGPoint) -> CGFloat
  func snapRecognizer(_ snapRecognizer: SnapGestureRecognizer, towardSnapPointAt point: CGPoint) -> CGPoint
  func snapRecognizerWillBeginPan(_ snapRecognizer: SnapGestureRecognizer)
  func snapRecognizerDidPan(_ snapRecognizer: SnapGestureRecognizer)
  func snapRecognizerDidEndPan(_ snapRecognizer: SnapGestureRecognizer)
  func snapRecognizerWillBeginSnap(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint)
  func snapRecognizerDidEndSnap(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint)
  func withSnapAnimation(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint)
}
```
You can make more customized gesture by using delegate.  
<img src="https://raw.githubusercontent.com/matsune/SnapGestureRecognizer/master/Assets/demo2.gif" width="200">

## SnapMenu
I made a snappable tableView menu UI by using SnapGestureRecognizer, like Facebook app. Please see Example projects for details.  
<img src="https://raw.githubusercontent.com/matsune/SnapGestureRecognizer/master/Assets/demo3.gif" width="200">

# License
SnapGestureRecognizer is released under an MIT license. See [LICENSE.md](LICENSE.md) for more information.
