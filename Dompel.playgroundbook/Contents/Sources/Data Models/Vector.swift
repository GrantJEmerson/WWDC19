//
//  Vector.swift
//  Dompel
//
//  Created by Grant Emerson on 1/30/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import Foundation


public struct Vector {
    public let x: Float
    public let y: Float
    public let z: Float
    
    static public func transfromYToVerticalPercentage(_ y: Float, withRadius radius: Float = 1) -> Float {
        let adjustedDiameter = Vector.getAdjustedDiameterFrom(radius)
        let adjustedRadius = adjustedDiameter / 2
        
        let verticalPercentage = (y + adjustedRadius) / adjustedDiameter
        
        return verticalPercentage
    }
    
    static public func tranfromVerticalPercentageToY(_ verticalPercentage: Float, withRadius radius: Float = 1) -> Float {
        let adjustedDiameter = getAdjustedDiameterFrom(radius)
        let adjustedRadius = adjustedDiameter / 2
        
        let y = ((adjustedDiameter * verticalPercentage) - adjustedRadius)
        
        return y
    }
    
    static public func createFromIndex(_ index: Int, verticalPercentage: Float = 0.5, withRadius radius: Float = 1) -> Vector {
        var transformedIndex = 12 - index
        if transformedIndex == 12 { transformedIndex = 0 }
        transformedIndex += 6
        if transformedIndex > 11 { transformedIndex = abs(12 - transformedIndex) }
        
        let angle = (360 / 12 * Float(transformedIndex)).toRadians()
        
        let y = Vector.tranfromVerticalPercentageToY(verticalPercentage, withRadius: radius)
        let radiusAtCrossSection = ((radius * radius) - (abs(y) * abs(y))).squareRoot()
        let x = radiusAtCrossSection * cos(angle)
        let z = radiusAtCrossSection * sin(angle)
        
        let vector = Vector(x: x, y: y, z: z)
        return vector
    }
    
    static private func getAdjustedDiameterFrom(_ radius: Float) -> Float {
        let speakerHeight: Float = 0.406
        let adjustedDiameter = (radius * 2) - speakerHeight
        return adjustedDiameter
    }
}


