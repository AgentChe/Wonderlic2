//
//  TestStatsTableInfoCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import UIKit

final class TestStatsTableInfoCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var correctAnswerCell = makeCell(placeholder: "TestStats.CorrectAnswers".localized)
    lazy var quizTimeCell = makeCell(placeholder: "TestStats.QuizTime".localized)
    lazy var weakSubjectCell = makeCell(placeholder: "TestStats.WeakSubject".localized)
    
    private lazy var quizTimeCellBottomConstraint = NSLayoutConstraint()
    
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
extension TestStatsTableInfoCell {
    func setup(element: TestStatsInfo) {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 15.scale))
            .lineHeight(18.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.right)
        
        correctAnswerCell.valueLabel.attributedText = String(format: "%i/%i", element.correctNumber, element.totalNumber).attributed(with: attrs)
        quizTimeCell.valueLabel.attributedText = element.quizTime.attributed(with: attrs)
        
        quizTimeCell.separator.isHidden = element.weakSubject == nil
        weakSubjectCell.separator.isHidden = true
        
        weakSubjectCell.isHidden = element.weakSubject == nil
        
        if let weakSubject = element.weakSubject {
            weakSubjectCell.valueLabel.attributedText = weakSubject.attributed(with: attrs)
        }
        
        if element.weakSubject == nil {
            quizTimeCellBottomConstraint.isActive = false
            quizTimeCellBottomConstraint = quizTimeCell.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            quizTimeCellBottomConstraint.isActive = true
        }
        
        layoutIfNeeded()
    }
}

// MARK: Private
private extension TestStatsTableInfoCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TestStatsTableInfoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            correctAnswerCell.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            correctAnswerCell.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            correctAnswerCell.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        quizTimeCellBottomConstraint = quizTimeCell.bottomAnchor.constraint(equalTo: weakSubjectCell.topAnchor)
        NSLayoutConstraint.activate([
            quizTimeCell.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            quizTimeCell.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            quizTimeCell.topAnchor.constraint(equalTo: correctAnswerCell.bottomAnchor),
            quizTimeCellBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            weakSubjectCell.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            weakSubjectCell.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            weakSubjectCell.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsTableInfoCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 12.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCell(placeholder: String) -> TestStatsInfoCell {
        let view = TestStatsInfoCell(placeholder: placeholder)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
