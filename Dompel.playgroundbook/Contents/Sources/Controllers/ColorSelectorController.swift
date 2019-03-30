//
//  ColorSelectorCollectionViewController.swift
//  Dompel
//
//  Created by Grant Emerson on 1/26/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

public class ColorSelectorController: UICollectionViewController {
    
    // MARK: Properties
    
    public weak var delegate: SoundSelectorDelegate?
    public var trackName: String!
    
    private let cellID = "ColorCell"
    
    private var color: NodeColor?
    
    private lazy var doneBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Node Color"
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    // MARK: Selector Functions
    
    @objc private func done() {
        guard let color = color else { return }
        delegate?.addSound(trackName, with: color)
        dismiss(animated: true)
    }

    // MARK: UICollectionViewDataSource

    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NodeColor.allCases.count
    }

    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        let color = NodeColor.allCases[indexPath.row]
        cell.backgroundColor = color.getUIColor()
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 15
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3.5
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    public override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.layer.borderColor = UIColor.black.cgColor
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.layer.borderColor = UIColor.lightGray.cgColor
        color = NodeColor.allCases[indexPath.row]
        doneBarButtonItem.isEnabled = true
    }
}

extension ColorSelectorController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width-50)/4
        return CGSize(width: width, height: width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
