//
//  TestStatsTableFilterCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import UIKit
import RxSwift

final class TestStatsTableFilterCell: UITableViewCell {
    weak var mainDelegate: TestStatsTableViewDelegate?
    
    lazy var allButton = makeButton(text: "TestStats.All".localized)
    lazy var incorrectButton = makeButton(text: "TestStats.Incorrect".localized)
    lazy var correctButton = makeButton(text: "TestStats.Correct".localized)
    
    private lazy var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
        update(filter: .all)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TestStatsTableFilterCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
        
        Observable
            .merge(
                allButton.rx.tap.map { TestStatsFilter.all },
                incorrectButton.rx.tap.map { TestStatsFilter.incorrect },
                correctButton.rx.tap.map { TestStatsFilter.correct }
            )
            .bind(to: Binder(self) { base, filter in
                base.mainDelegate?.testStatsTableDidTapped(filter: filter)
                base.update(filter: filter)
            })
            .disposed(by: disposeBag)
    }
    
    func update(filter: TestStatsFilter) {
        allButton.isChecked = filter == .all
        incorrectButton.isChecked = filter == .incorrect
        correctButton.isChecked = filter == .correct
    }
}

// MARK: Make constraints
private extension TestStatsTableFilterCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            allButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            allButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            allButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            allButton.widthAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            incorrectButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 82.scale),
            incorrectButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            incorrectButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            incorrectButton.widthAnchor.constraint(equalToConstant: 96.scale)
        ])
        
        NSLayoutConstraint.activate([
            correctButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 190.scale),
            correctButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            correctButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            correctButton.widthAnchor.constraint(equalToConstant: 86.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsTableFilterCell {
    func makeButton(text: String) -> TestStatsFilterButton {
        let view = TestStatsFilterButton(text: text)
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
