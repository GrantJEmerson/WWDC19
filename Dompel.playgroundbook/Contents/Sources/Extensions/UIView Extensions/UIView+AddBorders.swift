//
//  UIView+AddBorders.swift
//  Dompel
//
//  Created by Grant Emerson on 2/4/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

extension UIView {
    public func addBordersTo(_ edges: UIRectEdge, with color: UIColor, thickness: CGFloat = 1.0) {
        for edge in [UIRectEdge.top, .bottom, .left, .right] {
            guard edges.contains(edge) else { continue }
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = color
            add(view)
            switch edge {
            case .top:
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: trailingAnchor),
                    view.heightAnchor.constraint(equalToConstant: thickness),
                    view.topAnchor.constraint(equalTo: topAnchor)
                ])
            case .bottom:
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: trailingAnchor),
                    view.heightAnchor.constraint(equalToConstant: thickness),
                    view.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            case .left:
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: topAnchor),
                    view.bottomAnchor.constraint(equalTo: bottomAnchor),
                    view.widthAnchor.constraint(equalToConstant: thickness),
                    view.leadingAnchor.constraint(equalTo: leadingAnchor)
                ])
            case .right:
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: topAnchor),
                    view.bottomAnchor.constraint(equalTo: bottomAnchor),
                    view.widthAnchor.constraint(equalToConstant: thickness),
                    view.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
            case .all:
                layer.borderColor = color.cgColor
                layer.borderWidth = thickness
                return
            default:
                break
            }
        }
    }
}
