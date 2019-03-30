//
//  CircularLayout.swift
//  Dompel
//
//  Created by Grant Emerson on 1/26/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

public class CircularLayout: UICollectionViewLayout {
    
    // MARK: Properties
    
    private var center: CGPoint!
    private var itemSize: CGSize!
    private var radius: CGFloat!
    private var numberOfItems: Int!
    
    // MARK: Layout Life Cycle
    
    public override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        center = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
        let minLength = min(collectionView.bounds.width, collectionView.bounds.height)
        itemSize = CGSize(width: minLength * 0.15, height: minLength * 0.15)
        radius = minLength * 0.4
        numberOfItems = collectionView.numberOfItems(inSection: 0)
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let angle = 2 * .pi * CGFloat(indexPath.item) / CGFloat(numberOfItems)

        attributes.center = CGPoint(x: center.x + radius * cos(angle),
                                    y: center.y + radius * sin(angle))
        attributes.size = itemSize
        
        return attributes
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        
        let dataSourceLength = collectionView!.numberOfItems(inSection: 0)
        
        for i in 0 ..< dataSourceLength {
            let indexPath = IndexPath(item: i, section: 0)
            guard let attribute = layoutAttributesForItem(at: indexPath) else { continue }
            attributes.append(attribute)
        }
        
        return attributes
    }
}
