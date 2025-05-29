//
//  PlanStudyScoreView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 25.04.2022.
//

import UIKit

final class PlanStudyScoreView: UIView {
    lazy var titleLabel = makeLabel()
    lazy var goalLabel = makeLabel()
    lazy var progressLabel = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PlanStudyScoreView {
    func setup(goal: String, progress: Int) {
        let goalString = String(format: "Plan.StudyScore.Goal".localized, goal)
        goalLabel.attributedText = goalString
            .attributed(with: TextAttributes()
                            .textColor(Appearance.mono100.withAlphaComponent(0.8))
                            .font(Fonts.Inter.regular(size: 14.scale))
                            .lineHeight(19.6.scale)
                            .letterSpacing(-0.14.scale))
        
        let progressString = "\(progress)%"
        progressLabel.attributedText = progressString
            .attributed(with: TextAttributes()
                            .textColor(Appearance.mono100)
                            .font(Fonts.Inter.regular(size: 19.scale))
                            .lineHeight(26.6.scale)
                            .letterSpacing(-0.44.scale))
    }
}

// MARK: Private
private extension PlanStudyScoreView {
    func initialize() {
        titleLabel.attributedText = "Plan.StudyScore.Title".localized
            .attributed(with: TextAttributes()
                            .textColor(Appearance.mono100)
                            .font(Fonts.Inter.semiBold(size: 15.scale))
                            .lineHeight(18.scale)
                            .letterSpacing(-0.44.scale))
    }
}

// MARK: Make constraints
private extension PlanStudyScoreView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            goalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            goalLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            progressLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PlanStudyScoreView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
