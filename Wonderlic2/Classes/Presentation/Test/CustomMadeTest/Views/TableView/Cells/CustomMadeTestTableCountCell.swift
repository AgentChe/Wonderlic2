//
//  CustomMadeTestTableCountCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 15.06.2022.
//

import UIKit

final class CustomMadeTestTableCountCell: UITableViewCell {
    lazy var collectionView = makeCollectionView()
    lazy var countSelectedView = makeCountSelectedView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CustomMadeTestTableCountCell {
    func setup(element: [QuestionsCountCollectionElement]) {
        collectionView.setup(elements: element)
    }
}

// MARK: Private
private extension CustomMadeTestTableCountCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension CustomMadeTestTableCountCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            countSelectedView.widthAnchor.constraint(equalToConstant: 84.scale),
            countSelectedView.heightAnchor.constraint(equalToConstant: 54.scale),
            countSelectedView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            countSelectedView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CustomMadeTestTableCountCell {
    func makeCollectionView() -> QuestionsCountCollectionView {
        let layout = QuestionsCountCollectionLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 84.scale, height: 54.scale)
        
        let view = QuestionsCountCollectionView(frame: .zero, collectionViewLayout: layout)
        view.decelerationRate = .fast
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCountSelectedView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 12.scale
        view.layer.borderWidth = 2.scale
        view.layer.borderColor = Appearance.main300.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
