//
//  TrackCell.swift
//  Dompel
//
//  Created by Grant Emerson on 1/26/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

public class TrackCell: UICollectionViewCell {
    
    // MARK: Properties
    
    public var track: Track?
    
    public var editing: Bool = false {
        didSet {
            if editing {
                trackInitialsLabel.attributedText = NSAttributedString(string: track == nil ? "" : "X",
                                                                       attributes: [.foregroundColor: UIColor.red])
            } else {
                let title = track?.name.initials ?? "+"
                trackInitialsLabel.attributedText = NSAttributedString(string: title,
                                                                       attributes: [.foregroundColor : (track == nil) ? UIColor.themeColor : .black])
                backgroundColor = track?.color.getUIColor() ?? .white
            }
        }
    }

    private lazy var trackInitialsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-BOLD", size: 12)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? UIColor.lightGray.cgColor : UIColor.black.cgColor
        }
    }
    
    // MARK: Init
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        backgroundColor = .white
        trackInitialsLabel.attributedText = nil
        track = nil
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpSubviews()
    }
        
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Functions
    
    private func setUpView() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = frame.width / 2
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
    }
    
    private func setUpSubviews() {
        add(trackInitialsLabel)
        trackInitialsLabel.constrainToEdges()
    }
}
