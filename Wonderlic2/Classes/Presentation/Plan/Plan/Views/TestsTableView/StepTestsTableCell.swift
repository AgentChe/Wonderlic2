//
//  StepTestsTableCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 12.05.2022.
//

import UIKit

final class StepTestsTableCell: UITableViewCell {
    lazy var numberBackgroundView = makeNumberBackgroundView()
    lazy var numberLabel = makeLabel()
    lazy var nameLabel = makeLabel()
    lazy var questionsCountLabel = makeLabel()
    lazy var progressView = makeProgressView()
    lazy var lockedView = makeLockedView()
    
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
extension StepTestsTableCell {
    func setup(number: Int, element: PlanTest, activeSubscription: Bool, lockedStep: Bool) {
        let isLocked = isLocked(paid: element.paid, activeSubscription: activeSubscription, lockedStep: lockedStep)
        
        numberBackgroundView.image = UIImage(named: isLocked ? "Plan.Test.LockedNumber" : "Plan.Test.Number")
        
        numberLabel.attributedText = String(number)
            .attributed(with: TextAttributes()
                            .textColor(isLocked ? Appearance.main300 : Appearance.mono100)
                            .font(Fonts.Inter.black(size: 19.scale))
                            .lineHeight(22.8.scale)
                            .letterSpacing(-0.44.scale))
        
        nameLabel.attributedText = element.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.mono200)
                            .font(Fonts.Inter.semiBold(size: 15.scale))
                            .lineHeight(21.scale)
                            .letterSpacing(-0.44.scale))
        
        let questionsCount = String(format: "Plan.Test.Questions".localized, element.questionsCount)
        questionsCountLabel.attributedText = questionsCount
            .attributed(with: TextAttributes()
                            .textColor(Appearance.mono300)
                            .font(Fonts.Inter.regular(size: 14.scale))
                            .lineHeight(16.8.scale)
                            .letterSpacing(-0.44.scale))
        
        progressView.setup(progress: element.progress)
        progressView.isHidden = element.progress == 0
        
        numberLabel.alpha = isLocked ? 0.2 : 1
        nameLabel.alpha = isLocked ? 0.5 : 1
        questionsCountLabel.alpha = isLocked ? 0.5 : 1
        
        progressView.isHidden = isLocked
        lockedView.isHidden = !isLocked
    }
}

// MARK: Private
private extension StepTestsTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    func isLocked(paid: Bool, activeSubscription: Bool, lockedStep: Bool) -> Bool {
        if lockedStep {
            return true
        }
        
        return activeSubscription ? false : paid
    }
}

// MARK: Make constraints
private extension StepTestsTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            numberBackgroundView.widthAnchor.constraint(equalToConstant: 48.scale),
            numberBackgroundView.heightAnchor.constraint(equalToConstant: 48.scale),
            numberBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            numberBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: numberBackgroundView.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: numberBackgroundView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80.scale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            questionsCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80.scale),
            questionsCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 18.scale),
            progressView.heightAnchor.constraint(equalToConstant: 15.75.scale),
            progressView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -23.scale)
        ])
        
        NSLayoutConstraint.activate([
            lockedView.widthAnchor.constraint(equalToConstant: 24.scale),
            lockedView.heightAnchor.constraint(equalToConstant: 24.scale),
            lockedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lockedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension StepTestsTableCell {
    func makeNumberBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeProgressView() -> StepTestProgressView {
        let view = StepTestProgressView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLockedView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Plan.Test.Locked")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
