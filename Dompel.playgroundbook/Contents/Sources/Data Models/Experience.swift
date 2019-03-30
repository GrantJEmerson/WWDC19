//
//  Experience.swift
//  Dompel
//
//  Created by Grant Emerson on 1/26/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import Foundation

public struct Experience {
    
    // MARK: Static References
    
    public static let all = [
        Experience(name: "Corine, Corine", artist: "The Abletones Big Band",
                   genre: "Big Band Jazz", folderID: "A",
                   urlEndings: ["Drums", "E Guitar", "Kick", "Piano",
                                "Sax", "Trombone", "Trumpet", "Upright Bass"]),
        Experience(name: "Kings And Queens", artist: "thelvnguage",
                   genre: "Indie Soul", folderID: "B",
                   urlEndings: ["Bass", "Drums", "E Guitar", "Rhodes",
                                "Synth", "Vocals"]),
        Experience(name: "Milk Cow Blues", artist: "Angela Thomas Wade",
                   genre: "Country", folderID: "C",
                   urlEndings: ["Acoustic Guitar", "Bass", "Drums",
                                "Fiddle", "Piano", "Vocals"]),
        Experience(name: "Take It Off", artist: "Neon Hornet",
                   genre: "Grungey Blues Rock", folderID: "D",
                   urlEndings: ["Bass", "Drums", "E Guitar", "Vocals"]),
        Experience(name: "What Is This Thing Called Love", artist: "Jesper Buhl Trio",
                   genre: "Acoustic Jazz", folderID: "E",
                   urlEndings: ["Bass", "Drums", "Piano"])
    ]
    
    public static var selected = all[0] {
        didSet {
            NotificationCenter.default.post(name: .experienceChanged, object: nil)
        }
    }
    
    // MARK: Properties
    
    public let name: String
    public let artist: String
    public let genre: String
    public let folderID: String
    public let urlEndings: [String]
}
