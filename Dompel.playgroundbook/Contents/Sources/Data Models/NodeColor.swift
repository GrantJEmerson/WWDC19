//
//  NodeColor.swift
//  Dompel
//
//  Created by Grant Emerson on 1/29/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import Foundation
import UIKit

public enum NodeColor: CaseIterable {
    case yellow, yellowGreen, green, blueGreen, blue,
         blueViolet, violet, redViolet, red,
         redOrange, orange, yellowOrange
    
    public func getUIColor() -> UIColor {
        switch self {
        case .yellow:
            return #colorLiteral(red: 1, green: 1, blue: 0, alpha: 1)
        case .yellowGreen:
            return #colorLiteral(red: 0.2823529412, green: 1, blue: 0, alpha: 1)
        case .green:
            return #colorLiteral(red: 0.1137254902, green: 0.4745098039, blue: 0, alpha: 1)
        case .blueGreen:
            return #colorLiteral(red: 0.1607843137, green: 0.6823529412, blue: 0.6823529412, alpha: 1)
        case .blue:
            return #colorLiteral(red: 0, green: 0, blue: 1, alpha: 1)
        case .blueViolet:
            return #colorLiteral(red: 0.4509803922, green: 0.03137254902, blue: 0.6470588235, alpha: 1)
        case .violet:
            return #colorLiteral(red: 0.7294117647, green: 0, blue: 1, alpha: 1)
        case .redViolet:
            return #colorLiteral(red: 0.8, green: 0, blue: 0.6862745098, alpha: 1)
        case .red:
            return #colorLiteral(red: 0.9764705882, green: 0.05882352941, blue: 0.003921568627, alpha: 1)
        case .redOrange:
            return #colorLiteral(red: 0.9764705882, green: 0.2745098039, blue: 0.003921568627, alpha: 1)
        case .orange:
            return #colorLiteral(red: 0.9803921569, green: 0.4980392157, blue: 0.007843137255, alpha: 1)
        case .yellowOrange:
            return #colorLiteral(red: 0.9882352941, green: 0.7019607843, blue: 0, alpha: 1)
        }
    }
    
    public func getSpeakerTexture() -> UIImage {
        switch self {
        case .yellow:
            return UIImage(named: "YellowSpeaker")!
        case .yellowGreen:
            return UIImage(named: "YellowGreenSpeaker")!
        case .green:
            return UIImage(named: "GreenSpeaker")!
        case .blueGreen:
            return UIImage(named: "BlueGreenSpeaker")!
        case .blue:
            return UIImage(named: "BlueSpeaker")!
        case .blueViolet:
            return UIImage(named: "BlueVioletSpeaker")!
        case .violet:
            return UIImage(named: "VioletSpeaker")!
        case .redViolet:
            return UIImage(named: "RedVioletSpeaker")!
        case .red:
            return UIImage(named: "RedSpeaker")!
        case .redOrange:
            return UIImage(named: "RedOrangeSpeaker")!
        case .orange:
            return UIImage(named: "OrangeSpeaker")!
        case .yellowOrange:
            return UIImage(named: "YellowOrangeSpeaker")!
        }
    }
}

