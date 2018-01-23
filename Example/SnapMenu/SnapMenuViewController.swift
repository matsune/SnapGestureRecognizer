//
//  SnapMenuViewController.swift
//  SnapperDemo
//
//  Created by Yuma Matsune on 2018/01/22.
//  Copyright © 2018年 matsune. All rights reserved.
//

import Foundation
import SnapGestureRecognizer
import UIKit

final class SnapMenuViewController: UIViewController {
    
    let menuView = MenuView()
    let snapGesture = SnapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 44
        
        let point1 = SnapPoint(CGPoint(x: 0, y: statusBarHeight + navBarHeight),
                               snapKey: "point1")
        let point2 = SnapPoint(CGPoint(x: 0, y: view.center.y),
                               snapKey: "point2")
        let point3 = SnapPoint(CGPoint(x: 0, y: view.bounds.height - 100),
                               snapKey: "point3")
        
        menuView.frame = CGRect(origin: point2.cgPoint, size: view.bounds.size)
        menuView.tableView.delegate = self
        menuView.tableView.dataSource = self
        menuView.tableView.isScrollEnabled = false
        view.addSubview(menuView)
        
        snapGesture.snapPoints = [point1, point2, point3]
        snapGesture.anchorPoint = .origin
        snapGesture.panDirection = .vertical
        snapGesture.snapDelegate = self
        snapGesture.delegate = self
        menuView.addGestureRecognizer(snapGesture)
    }
}

extension SnapMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        }
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? MenuHeaderCell else {
                fatalError()
            }
            cell.selectionStyle = .none
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            fatalError()
        }
        cell.textLabel?.text = "\(indexPath)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if snapGesture.beganPoint.snapKey == "point3" && indexPath.row == 0 {
            snapGesture.snap(to: "point2")
        }
    }
}

extension SnapMenuViewController: SnapGestureRecognizerDelegate {
    func snapRecognizerWillBeginSnap(_ snapRecognizer: SnapGestureRecognizer, began: SnapPoint, toward: SnapPoint) {
        if toward.snapKey == "point1" {
            menuView.tableView.isScrollEnabled = true
        } else {
            menuView.tableView.isScrollEnabled = false
        }
    }
}

extension SnapMenuViewController: UIGestureRecognizerDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < 0 && decelerate {
            snapGesture.snap(to: "point2")
        }
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let s = gestureRecognizer as? SnapGestureRecognizer {
            if s.beganPoint.snapKey == "point1" {
                // At the point1, Snapper gesture should be disable
                // when tableView content scrolls to up.
                if menuView.tableView.contentOffset.y > 0 {
                    return false
                }
            }
        }
        return true
    }
}
