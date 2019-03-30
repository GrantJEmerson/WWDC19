//
//  String+Initials.swift
//  Dompel
//
//  Created by Grant Emerson on 1/26/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import Foundation

extension String {
    public var initials: String {
        var string = self
        var initials = String(string.removeFirst())
        for (i, s) in string.enumerated() {
            if s == " " && i < (string.count-1) {
                initials += String(string[index(startIndex, offsetBy: i+1)])
            }
        }
        return initials.uppercased()
    }
}
