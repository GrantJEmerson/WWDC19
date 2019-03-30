//
//  UIView+ConstrainToEdges.swift
//  3D Audio Experiment
//
//  Created by Grant Emerson on 1/19/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

extension UIView {
    public func constrainToEdges() {
        guard let superview = superview else { return }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
}
