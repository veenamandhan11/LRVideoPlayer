//
//  UICollectionView+Extension.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import UIKit

extension UICollectionView {
    func getMostVisibleCell<T: UICollectionViewCell>() -> T? {
        guard let visibleCells = self.visibleCells as? [T], !visibleCells.isEmpty else {
            return nil
        }
        
        let collectionViewCenter = self.bounds.midY - self.contentOffset.y
        var closestCell: T?
        var closestDistance: CGFloat = .greatestFiniteMagnitude
        
        for cell in visibleCells {
            let cellCenterInCollectionView = CGPoint(x: cell.bounds.midX, y: cell.bounds.midY)
            let cellCenterInSuperview = cell.convert(cellCenterInCollectionView, to: self.superview)
            let cellCenterY = cellCenterInSuperview.y
            let distance = abs(cellCenterY - collectionViewCenter)
            if distance <= closestDistance {
                closestDistance = distance
                closestCell = cell
            }
        }
        
        return closestCell
    }
}
