//
//  DecibelMarkingView.swift
//  Dompel
//
//  Created by Grant Emerson on 2/12/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

public class DecibelMarkingView: UIView {
    
    // MARK: Properties
    
    public var maxDecibels: Int = 0 {
        didSet {
            topDecibelLabel.text = "\(maxDecibels) dB"
            bottomDecibelLabel.text = "\(maxDecibels-40) dB"
        }
    }
    
    private let DecibelLabel: () -> (UILabel) = {
        let label = UILabel()
        label.text = "-20 dB"
        label.font = UIFont(name: "Futura", size: 13)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private lazy var topDecibelLabel = DecibelLabel()
    private lazy var middleDecibelLabel = DecibelLabel()
    private lazy var bottomDecibelLabel = DecibelLabel()
    
    // MARK: View Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        ({ self.maxDecibels = 0 })()

    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
        ({ self.maxDecibels = 0 })()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setUpSubviews()
    }
    
    // MARK: Private Functions
    
    private func setUpSubviews() {
        add(topDecibelLabel, middleDecibelLabel, bottomDecibelLabel)
        
        let labels = [topDecibelLabel, middleDecibelLabel, bottomDecibelLabel]
        
        labels.forEach {
            $0.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            topDecibelLabel.topAnchor.constraint(equalTo: topAnchor),
            bottomDecibelLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            middleDecibelLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
