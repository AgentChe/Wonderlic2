//
//  PlanFinalStepView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 16.05.2022.
//

import UIKit

final class PlanFinalStepView: UIView {
    lazy var titleLabel = makeLabel()
    lazy var subTitleLabel = makeLabel()
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
extension PlanFinalStepView {
    func setup(finalStep: PlanFinalStep, locked: Bool) {
        let titleAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.regular(size: 15.scale))
            .lineHeight(22.5.scale)
            .letterSpacing(-0.14.scale)
            .textAlignment(.center)
        
        let subTitleAttrs = TextAttributes()
            .textColor(Appearance.mono300)
            .font(Fonts.Inter.regular(size: 15.scale))
            .lineHeight(22.5.scale)
            .letterSpacing(-0.14.scale)
            .textAlignment(.center)
        
        let buttonAttrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .letterSpacing(-0.44.scale)
        
        let title: String
        let subTitle: String
        let buttonText: String
        
        switch finalStep.status {
        case .intact:
            title = "Plan.FinalStep.Title1".localized
            subTitle = "Plan.FinalStep.SubTitle1".localized
            buttonText = "Plan.FinalStep.Button1".localized
        case .inProgress:
            title = "Plan.FinalStep.Title2".localized
            subTitle = "Plan.FinalStep.SubTitle2".localized
            buttonText = "Plan.FinalStep.Button2".localized
        case .completed:
            title = "Plan.FinalStep.Title3".localized
            subTitle = String(format: "Plan.FinalStep.SubTitle3".localized, finalStep.progress ?? 0)
            buttonText = "Plan.FinalStep.Button3".localized
        }
        
        titleLabel.attributedText = title.attributed(with: titleAttrs)
        subTitleLabel.attributedText = subTitle.attributed(with: subTitleAttrs)
        button.setAttributedTitle(buttonText.attributed(with: buttonAttrs), for: .normal)
        
        button.isEnabled = !locked
        button.alpha = locked ? 0.4 : 1
    }
}

// MARK: Make constraints
private extension PlanFinalStepView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            button.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 24.scale),
            button.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PlanFinalStepView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

