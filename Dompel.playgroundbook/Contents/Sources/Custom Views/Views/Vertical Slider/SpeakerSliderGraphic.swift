//
//  CustomSpeakerVerticalSliderGraphic.swift
//  Dompel
//
//  Created by Grant Emerson on 2/6/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

public class SpeakerSliderGraphic: NSObject {
    
    // MARK: Drawing Method
    
    @objc dynamic public class func drawSliderIn(_ targetFrame: CGRect = CGRect(x: 0, y: 0, width: 55, height: 100),
                                                 withPercent percent: CGFloat,
                                                 resizing: ResizingBehavior = .aspectFit,
                                                 enabled: Bool) {
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 55, height: 100), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 55, y: resizedFrame.height / 100)
        
        // Speaker Sphere Drawing
        let speakerSpherePath = UIBezierPath()
        speakerSpherePath.move(to: CGPoint(x: 50.5, y: 97.5))
        speakerSpherePath.addCurve(to: CGPoint(x: 3, y: 50.25), controlPoint1: CGPoint(x: 24.27, y: 97.5), controlPoint2: CGPoint(x: 3, y: 76.35))
        speakerSpherePath.addCurve(to: CGPoint(x: 50.5, y: 3), controlPoint1: CGPoint(x: 3, y: 24.15), controlPoint2: CGPoint(x: 24.27, y: 3))
        UIColor.black.setStroke()
        speakerSpherePath.lineWidth = 2
        speakerSpherePath.lineCapStyle = .round
        speakerSpherePath.stroke()
        
        // Speaker Group
        context.saveGState()
        context.translateBy(x: 50.5, y: 50)
        let degree = enabled ? ((138 * percent) - 69) : 0
        context.rotate(by: degree * CGFloat.pi/180)
        
        // Speaker Body Drawing
        let speakerBodyPathRect = CGRect(x: -44.5, y: -10, width: 8, height: 20)
        let speakerBodyPath = UIBezierPath(roundedRect: speakerBodyPathRect, cornerRadius: 3)
        (enabled ? UIColor.themeColor : .darkGray).setFill()
        speakerBodyPath.fill()
        UIColor.black.setStroke()
        speakerBodyPath.lineWidth = 0.5
        speakerBodyPath.stroke()
        
        // Bottom Arrow Drawing
        context.saveGState()
        context.translateBy(x: -38.24, y: 12.21)
        context.rotate(by: -90 * CGFloat.pi/180)
        
        let bottomArrowPath = UIBezierPath()
        bottomArrowPath.move(to: CGPoint(x: 0, y: -3))
        bottomArrowPath.addLine(to: CGPoint(x: 2.6, y: 1.5))
        bottomArrowPath.addLine(to: CGPoint(x: -2.6, y: 1.5))
        bottomArrowPath.close()
        UIColor.darkGray.setFill()
        bottomArrowPath.fill()
        UIColor.black.setStroke()
        bottomArrowPath.lineWidth = 0.5
        bottomArrowPath.stroke()
        
        context.restoreGState()
        
        // Top Arrow Drawing
        context.saveGState()
        context.translateBy(x: -38.24, y: -12.29)
        context.rotate(by: -90 * CGFloat.pi/180)
        
        let topArrowPath = UIBezierPath()
        topArrowPath.move(to: CGPoint(x: 0, y: -3))
        topArrowPath.addLine(to: CGPoint(x: 2.6, y: 1.5))
        topArrowPath.addLine(to: CGPoint(x: -2.6, y: 1.5))
        topArrowPath.close()
        UIColor.darkGray.setFill()
        topArrowPath.fill()
        UIColor.black.setStroke()
        topArrowPath.lineWidth = 0.5
        topArrowPath.stroke()
        
        context.restoreGState()
        
    }
    
    @objc(SpeakerSliderResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.
        
        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}

