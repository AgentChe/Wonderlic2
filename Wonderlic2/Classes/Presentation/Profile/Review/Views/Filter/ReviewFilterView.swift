//
//  ReviewFilterView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

import UIKit

enum ReviewFilter {
    case all, incorrect, correct
}

final class ReviewFilterView: UIView {
    var filter: ReviewFilter = .all {
        didSet {
            update()
        }
    }
    
    lazy var allButton = makeButton(title: "Review.All".localized)
    lazy var incorrectButton = makeButton(title: "Review.Incorrect".localized)
    lazy var correctButton = makeButton(title: "Review.Correct".localized)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ReviewFilterView {
    func update() {
        let buttons = [
            allButton,
            incorrectButton,
            correctButton
        ]
        
        buttons.forEach {
            $0.isChecked = false
        }
        
        switch filter {
        case .all: allButton.isChecked = true
        case .incorrect: incorrectButton.isChecked = true
        case .correct: correctButton.isChecked = true
        }
    }
}

// MARK: Make constraints
private extension ReviewFilterView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            allButton.widthAnchor.constraint(equalToConstant: 50.scale),
            allButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            allButton.topAnchor.constraint(equalTo: topAnchor),
            allButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            incorrectButton.widthAnchor.constraint(equalToConstant: 96.scale),
            incorrectButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 82.scale),
            incorrectButton.topAnchor.constraint(equalTo: topAnchor),
            incorrectButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            correctButton.widthAnchor.constraint(equalToConstant: 86.scale),
            correctButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 190.scale),
            correctButton.topAnchor.constraint(equalTo: topAnchor),
            correctButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ReviewFilterView {
    func makeButton(title: String) -> ReviewFilterButton {
        let view = ReviewFilterButton(title: title)
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
