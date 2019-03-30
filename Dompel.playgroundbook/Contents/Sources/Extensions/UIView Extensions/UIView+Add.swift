//
//  UIView+Add.swift
//  3D Audio Experiment
//
//  Created by Grant Emerson on 1/19/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

extension UIView {
    public func add(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
