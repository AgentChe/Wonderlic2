//
//  StepCollectionView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 04.05.2022.
//

import UIKit

protocol StepCollectionViewDelegate: AnyObject {
    func stepCollectionViewDidSelect(element: StepCollectionElement)
}

final class StepCollectionView: UICollectionView {
    weak var mainDelegate: StepCollectionViewDelegate?
    
    lazy var elements = [StepCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension StepCollectionView {
    func setup(elements: [StepCollectionElement]) {
        self.elements = elements
        
        reloadData()
        
        if let index = StepCollectionElement.currentIndex(in: elements) {
            scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: false)
        }
    }
}

// MARK: UICollectionViewDataSource
extension StepCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .tests(let element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: StepCollectionCell.self), for: indexPath) as! StepCollectionCell
            cell.setup(progress: element.step.progress, locked: element.locked)
            return cell
        case .final(let element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: StepCollectionFinalCell.self), for: indexPath) as! StepCollectionFinalCell
            cell.setup(progress: element.finalStep.progress ?? 0)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension StepCollectionView: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let maxCell = visibleCells.max(by: { $0.transform.a < $1.transform.a }) else {
            return
        }
        
        guard let indexPath = indexPath(for: maxCell) else {
            return
        }
        
        let element = elements[indexPath.row]
        
        mainDelegate?.stepCollectionViewDidSelect(element: element)
    }
}

// MARK: Private
private extension StepCollectionView {
    func initialize() {
        register(StepCollectionCell.self, forCellWithReuseIdentifier: String(describing: StepCollectionCell.self))
        register(StepCollectionFinalCell.self, forCellWithReuseIdentifier: String(describing: StepCollectionFinalCell.self))
        
        dataSource = self
        delegate = self
    }
}
