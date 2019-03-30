//
//  Track.swift
//  Dompel
//
//  Created by Grant Emerson on 1/30/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import Foundation

public struct Track {
    public static var selected: Track? {
        didSet {
            NotificationCenter.default.post(name: .selectedTrackChanged, object: nil)
        }
    }
    
    public let id: String
    public let name: String
    public let index: Int
    public let color: NodeColor
}
