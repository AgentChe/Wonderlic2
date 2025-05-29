//
//  QuestionsCountCollectionView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 15.06.2022.
//

import UIKit

final class QuestionsCountCollectionView: UICollectionView {
    private lazy var elements = [QuestionsCountCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension QuestionsCountCollectionView {
    func setup(elements: [QuestionsCountCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension QuestionsCountCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: QuestionsCountCollectionCell.self), for: indexPath) as! QuestionsCountCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension QuestionsCountCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 84.scale, height: 54.scale)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let point = CGPoint(x: center.x + contentOffset.x,
                            y: center.y + contentOffset.y);
        
        guard let indexPath = indexPathForItem(at: point) else {
            return
        }
        
        elements.enumerated().forEach { index, element in
            element.isSelected = index == indexPath.row
        }
        
        reloadData()
    }
}

// MARK: Private
private extension QuestionsCountCollectionView {
    func initialize() {
        register(QuestionsCountCollectionCell.self, forCellWithReuseIdentifier: String(describing: QuestionsCountCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
