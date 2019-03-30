//
//  UIButton+Default.swift
//  Dompel
//
//  Created by Grant Emerson on 1/30/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

extension UIButton {
    static public func createDefault(withRadius radius: CGFloat = 15) -> UIButton {
        let button = UIButton()
        button.titleLabel!.font = UIFont(name: "Arial Rounded MT Bold", size: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = radius
        button.backgroundColor = .themeColor
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
