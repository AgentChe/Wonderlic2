//
//  QuestionsCountCollectionLayout.swift
//  ITExams
//
//  Created by Андрей Чернышев on 15.06.2022.
//

import UIKit

final class QuestionsCountCollectionLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            let horizontalInset = collectionView.bounds.width / 2 - itemSize.width / 2
            collectionView.contentInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }

        let width = itemSize.width + minimumLineSpacing
        var offset = proposedContentOffset.x + collectionView.contentInset.left

        if velocity.x > 0 {
          offset = width * ceil(offset / width)
        } else if velocity.x == 0 {
          offset = width * round(offset / width)
        } else if velocity.x < 0 {
          offset = width * floor(offset / width)
        }

        return CGPoint(x: offset - collectionView.contentInset.left, y: 0)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
