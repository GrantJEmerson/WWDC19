//
//  UIViewController+PresentUp.swift
//  Modulin
//
//  Created by Grant Emerson on 2/21/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

extension UIViewController {
    public func presentPopUp(_ viewController: UIViewController, withSize size: CGSize,
                      by source: UIView, direction: UIPopoverArrowDirection = .up) {
        guard let `self` = self as? UIPopoverPresentationControllerDelegate else { return }
        viewController.modalPresentationStyle = .popover
        viewController.popoverPresentationController?.permittedArrowDirections = direction
        viewController.popoverPresentationController?.delegate = self
        viewController.popoverPresentationController?.sourceView = source
        viewController.popoverPresentationController?.sourceRect = source.bounds
        viewController.preferredContentSize = size
        present(viewController, animated: true)
    }
}

