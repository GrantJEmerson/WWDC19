//
//  RoundedEditorModuleView.swift
//  Dompel
//
//  Created by Grant Emerson on 2/11/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

public class RoundedEditorModuleView: UIView {
    
    // MARK: Properties
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura-BOLD", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var roundedView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setUpSubviews()
    }
    
    // MARK: Private Functions
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 25
        layer.borderWidth = 3.5
        layer.borderColor = UIColor.darkGray.cgColor
    }
    
    private func setUpSubviews() {
        add(titleLabel, roundedView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.heightAnchor.constraint(equalToConstant: 21),
            
            roundedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            roundedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            roundedView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            roundedView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
