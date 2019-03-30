//
//  VerticalSlider.swift
//  Dompel
//
//  Created by Grant Emerson on 2/5/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

enum SliderType {
    case vertical, speaker
}

class VerticalSlider: UIControl {
    
    // MARK: Properties
    
    private let sliderType: SliderType
    
    public var callback: (Double) -> Void = { _ in }
    public var minValue: Double = 0.0
    public var maxValue: Double = 1.0
    
    public var value: Double = 0.5 {
        didSet {
            if value < minValue {
                value = minValue
            }
            if value > maxValue {
                value = maxValue
            }
            sliderPercentage = CGFloat((value - minValue) / (maxValue - minValue))
        }
    }
    
    public var thumbSize: CGSize = CGSize(width: 25, height: 15) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var bodyWidth: CGFloat = 15 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var sliderPercentage: CGFloat = 0.5 {
        didSet { setNeedsDisplay() }
    }
    
    private var isSliding = false

    private var thumbRect: CGRect = .zero
    
    public override var isEnabled: Bool {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: View Life Cycle
    
    public init(type: SliderType) {
        sliderType = type
        super.init(frame: .zero)
        contentMode = .redraw
        backgroundColor = .clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        sliderType = .vertical
        super.init(frame: .zero)
        contentMode = .redraw
        backgroundColor = .clear
    }
    
    public override func draw(_ rect: CGRect) {
        if sliderType == .vertical {
            thumbRect = VerticalSliderGraphic.drawIn(rect, withPercent: sliderPercentage,
                                                     thumbSize: thumbSize, width: bodyWidth, enabled: isEnabled)
        } else {
            SpeakerSliderGraphic.drawSliderIn(rect, withPercent: sliderPercentage, enabled: isEnabled)
        }
    }
    
    // MARK: Private Functions
    
    private func getValueFromY(_ y: CGFloat) -> Double {
        let percentage = Double((bounds.height - y) / bounds.height)
        let value = (percentage * (maxValue - minValue)) + minValue
        return value
    }
    
}

// MARK: Control Touch Handling
extension VerticalSlider {
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let extendedThumbRect = CGRect(x: thumbRect.origin.x, y: thumbRect.origin.y - 5,
                                       width: thumbSize.width, height: thumbSize.height + 10)
        if extendedThumbRect.contains(touch.location(in: self)) || sliderType == .speaker {
            isSliding = true
        }
        return true
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let y = touch.location(in: self).y
        
        if isSliding {
            value = getValueFromY(y)
            callback(value)
        }
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isSliding = false
    }
}
