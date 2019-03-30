//
//  SliderStyleKit.swift
//  Dompel
//
//  Created by Grant Emerson on 2/5/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

public class VerticalSliderGraphic: NSObject {

    // MARK: Drawing Method

    @objc dynamic public class func drawIn(_ frame: CGRect, withPercent percent: CGFloat, thumbSize: CGSize, width: CGFloat, enabled: Bool) -> CGRect {
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        // Size Property Declarations
        let thumbWidth: CGFloat = thumbSize.width
        let thumbHeight: CGFloat = thumbSize.height
        
        let bodyWidth = width
        let height = frame.height
        let adjustedHeight = frame.height - thumbHeight
        
        // Drawing Slider Body
        let bodyPathRect = CGRect(x: frame.midX - (bodyWidth / 2), y: 0,
                                  width: bodyWidth, height: height)
        let bodyPath = UIBezierPath(roundedRect: bodyPathRect, cornerRadius: 4)
        UIColor.gray.setFill()
        bodyPath.fill()
        UIColor.black.setStroke()
        bodyPath.lineWidth = 1
        bodyPath.stroke()
        
        // Drawing Slider Indicator
        let indicatorY = (adjustedHeight - (adjustedHeight * (enabled ? percent : 0))) + (thumbHeight / 2)
        let indicatorHeight = height - indicatorY
        let indicatorPathRect = CGRect(x: frame.midX - (bodyWidth / 2), y: indicatorY,
                                       width: bodyWidth, height: indicatorHeight)
        let indicatorPath = UIBezierPath(roundedRect: indicatorPathRect, cornerRadius: 4)
        UIColor.lightGray.setFill()
        indicatorPath.fill()
        UIColor.black.setStroke()
        indicatorPath.lineWidth = 1
        indicatorPath.stroke()
        
        // Drawing Slider Thumb
        
        let thumbPathRect = CGRect(x: frame.midX - (thumbWidth / 2), y: indicatorY - (thumbHeight / 2),
                                   width: thumbWidth, height: thumbHeight)
        let thumbPath = UIBezierPath(roundedRect: thumbPathRect, cornerRadius: 4)
        let thumbColor = (enabled ? UIColor.themeColor : .gray)
        thumbColor.setFill()
        //context.setShadow(offset: .zero, blur: 6, color: thumbColor.cgColor)
        thumbPath.fill()
        UIColor.black.setStroke()
        thumbPath.lineWidth = 1
        thumbPath.stroke()
        
        context.restoreGState()
        
        return thumbPathRect
    }

}
