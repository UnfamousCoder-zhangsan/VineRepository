//
//  GSCountdownButton.swift
//  GSCountdownButton
//
//  Created by Gesen on 15/6/4.
//  Copyright (c) 2015年 Gesen. All rights reserved.
//

import UIKit
@objcMembers
class GSCountdownButton: UIButton {
    // MARK: Properties

    var maxSecond = 60
    var countdown = false {
        didSet {
            if oldValue != countdown {
                countdown ? startCountdown() : stopCountdown()
            }
        }
    }

    var timeLabel: UILabel!
    var normalText: String!
    var normalTextColor: UIColor!
    var disabledText: String!
    var disabledTextColor: UIColor!

    private var second = 0
    private var timer: Timer?

    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel()
    }

    deinit {
        countdown = false
    }

    // MARK: Setups

    private func setupLabel() {
        normalText = title(for: .normal) ?? ""
        disabledText = title(for: .disabled) ?? ""
        normalTextColor = titleColor(for: .normal) ?? .white
        disabledTextColor = titleColor(for: .disabled) ?? .white
        setTitle("", for: .normal)
        setTitle("", for: .disabled)
        timeLabel = UILabel(frame: bounds)
        timeLabel.textAlignment = .right
        timeLabel.font = titleLabel?.font
        timeLabel.textColor = normalTextColor
        timeLabel.text = normalText
        addSubview(timeLabel)
    }

    // MARK: Private

    private func startCountdown() {
        if timeLabel == nil {
            setupLabel()
        }

        second = maxSecond
        timeLabel.text = disabledText.replacingOccurrences(of: "second", with: "\(second)")

        updateDisabled()

        if timer != nil {
            timer!.invalidate()
            timer = nil
        }

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    private func stopCountdown() {
        timer?.invalidate()
        timer = nil
        updateNormal()
    }

    public func updateNormal() {
        isEnabled = true
        timeLabel.textColor = normalTextColor
        timeLabel.text = normalText
    }

    public func updateDisabled() {
        isEnabled = false
        timeLabel.textColor = disabledTextColor
    }

    @objc private func updateCountdown() {
        second -= 1
        if second <= 0 {
            countdown = false
        } else {
            updateDisabled()
            timeLabel.text = disabledText.replacingOccurrences(of: "second", with: "\(second)")
        }
    }
}
