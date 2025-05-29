//
//  PracticeTableTestsCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 09.06.2022.
//

import UIKit

final class PracticeTableTestsCell: UITableViewCell {
    weak var mainDelegate: PracticeTableViewDelegate?
    
    lazy var container = makeContainer()
    lazy var randomButton = makeButton(icon: "Practice.RandomTest", name: "Practice.Tests.RandomTest".localized)
    lazy var missedButton = makeButton(icon: "Practice.MissedTest", name: "Practice.Tests.MissedTest".localized)
    lazy var quickButton = makeButton(icon: "Practice.QuickTest", name: "Practice.Tests.QuickTest".localized)
    lazy var savedButton = makeButton(icon: "Practice.SavedTest", name: "Practice.Tests.SavedTest".localized)
    lazy var customButton = makeButton(icon: "Practice.CustomTest", name: "Practice.Tests.CustomMade".localized)
    
    private var element: PracticeTableTestsCount!
    
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
extension PracticeTableTestsCell {
    func setup(element: PracticeTableTestsCount) {
        self.element = element
        
        let attrs = TextAttributes()
            .textColor(Appearance.mono300.withAlphaComponent(0.7))
            .font(Fonts.Inter.regular(size: 14.scale))
            .lineHeight(19.6.scale)
            .letterSpacing(-0.14.scale)
        
        randomButton.subTitleLabel.attributedText = String(format: "Practice.Tests.QuestionsCount".localized, element.random).attributed(with: attrs)
        missedButton.subTitleLabel.attributedText = String(format: "Practice.Tests.QuestionsCount".localized, element.missed).attributed(with: attrs)
        quickButton.subTitleLabel.attributedText = String(format: "Practice.Tests.QuestionsCount".localized, element.quick).attributed(with: attrs)
        savedButton.subTitleLabel.attributedText = String(format: "Practice.Tests.QuestionsCount".localized, element.saved).attributed(with: attrs)
        customButton.subTitleLabel.attributedText = "Practice.Tests.CustomMadeSubTitle".localized.attributed(with: attrs)
        customButton.separator.isHidden = true
    }
}

// MARK: Private
private extension PracticeTableTestsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func tapped(sender: UIGestureRecognizer) {
        guard let button = sender.view as? PracticeTestButton else {
            return
        }
        
        if button === randomButton {
            mainDelegate?.practiceTableDidTappedRandomTest()
        } else if button === missedButton {
            mainDelegate?.practiceTableDidTappedMissedTest(questionsCount: element.missed)
        } else if button === quickButton {
            mainDelegate?.practiceTableDidTappedQuickTest()
        } else if button === savedButton {
            mainDelegate?.practiceTableDidTappedSavedTest(questionsCount: element.saved)
        } else if button === customButton {
            mainDelegate?.practiceTableDidTappedCustomTest()
        }
    }
}

// MARK: Make constraints
private extension PracticeTableTestsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            randomButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            randomButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            randomButton.topAnchor.constraint(equalTo: container.topAnchor),
            randomButton.heightAnchor.constraint(equalToConstant: 81.6.scale)
        ])
        
        NSLayoutConstraint.activate([
            missedButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            missedButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            missedButton.topAnchor.constraint(equalTo: randomButton.bottomAnchor),
            missedButton.heightAnchor.constraint(equalToConstant: 81.6.scale)
        ])
        
        NSLayoutConstraint.activate([
            quickButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            quickButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            quickButton.topAnchor.constraint(equalTo: missedButton.bottomAnchor),
            quickButton.heightAnchor.constraint(equalToConstant: 81.6.scale)
        ])
        
        NSLayoutConstraint.activate([
            savedButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            savedButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            savedButton.topAnchor.constraint(equalTo: quickButton.bottomAnchor),
            savedButton.heightAnchor.constraint(equalToConstant: 81.6.scale)
        ])
        
        NSLayoutConstraint.activate([
            customButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            customButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            customButton.topAnchor.constraint(equalTo: savedButton.bottomAnchor),
            customButton.heightAnchor.constraint(equalToConstant: 81.6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PracticeTableTestsCell {
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
    
    func makeButton(icon: String, name: String) -> PracticeTestButton {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(sender:)))
        
        let view = PracticeTestButton(name: name)
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.clear
        view.iconView.image = UIImage(named: icon)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
