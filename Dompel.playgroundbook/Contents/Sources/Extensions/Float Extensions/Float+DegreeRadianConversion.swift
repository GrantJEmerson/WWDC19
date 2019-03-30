//
//  Float+toDegrees.swift
//  Dompel
//
//  Created by Grant Emerson on 1/26/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import Foundation

extension Float {
    public func toDegrees() -> Float {
        return self * 180.0 / .pi
    }
    public func toRadians() -> Float {
        return self * .pi / 180.0
    }
}
