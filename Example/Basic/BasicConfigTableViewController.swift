//
//  BasicConfigTableViewController.swift
//  SnapperDemo
//
//  Created by Yuma Matsune on 2018/01/20.
//  Copyright © 2018年 matsune. All rights reserved.
//

import Foundation
import UIKit

final class BasicConfigTableViewController: UITableViewController {

    let kSnapToRestoreId = "SnapTo"
    let kPanDirectionRestoreId = "PanDirection"
    
    @IBOutlet weak var decayLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var dampingLabel: UILabel!
    @IBOutlet weak var springLabel: UILabel!
    
    var onChangeSnapTo: ((_ row: Int) -> Void)?
    var onChangePanDirection: ((_ row: Int) -> Void)?
    var onChangeDecay: ((_ value: Float) -> Void)?
    var onChangeDuration: ((_ value: Float) -> Void)?
    var onChangeDelay: ((_ value: Float) -> Void)?
    var onChangeDamping: ((_ value: Float) -> Void)?
    var onChangeSpring: ((_ value: Float) -> Void)?
    
    @IBAction func onChangeDecay(_ sender: UISlider) {
        decayLabel.text = "decay: \(sender.value)"
        onChangeDecay?(sender.value)
    }
    
    @IBAction func onChangeDuration(_ sender: UISlider) {
        durationLabel.text = "duration: \(sender.value)"
        onChangeDuration?(sender.value)
    }
    
    @IBAction func onChangeDelay(_ sender: UISlider) {
        delayLabel.text = "delay: \(sender.value)"
        onChangeDelay?(sender.value)
    }
    
    @IBAction func onChangeDampingVelocity(_ sender: UISlider) {
        dampingLabel.text = "damping: \(sender.value)"
        onChangeDamping?(sender.value)
    }
    
    @IBAction func onChangeSptingVelocity(_ sender: UISlider) {
        springLabel.text = "springLabel: \(sender.value)"
        onChangeSpring?(sender.value)
    }
}

extension BasicConfigTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.restorationIdentifier {
        case kSnapToRestoreId?, kPanDirectionRestoreId?:
            return 3
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.restorationIdentifier {
        case kSnapToRestoreId?:
            return ["direction", "nearest", "custom"][row]
        case kPanDirectionRestoreId?:
            return ["diagonal", "horizontal", "vertical"][row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.restorationIdentifier {
        case kSnapToRestoreId?:
            onChangeSnapTo?(row)
        case kPanDirectionRestoreId?:
            onChangePanDirection?(row)
        default:
            break
        }
    }
}
