//
//  OQuizResultView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.03.2022.
//

import UIKit

final class OQuizResultView: OSlideView {
    lazy var headerLabel = makeHeaderLabel()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var cursorView = makeCursorView()
    lazy var beginnerProgressView = makeProgressView()
    lazy var beginnerFilledProgressView = makeProgressView()
    lazy var middleProgressView = makeProgressView()
    lazy var middleFilledProgressView = makeProgressView()
    lazy var advancedProgressView = makeProgressView()
    lazy var beginnerProgressLabel = makeProgressLabel()
    lazy var middleProgressLabel = makeProgressLabel()
    lazy var advancedProgressLabel = makeProgressLabel()
    lazy var button = makeButton()
    
    private lazy var beginnerFilledWidth = NSLayoutConstraint()
    private lazy var middleFilledWidth = NSLayoutConstraint()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        beginnerFilledWidth.constant = 108.scale
        
        UIView.animate(withDuration: 1, animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.layoutIfNeeded()
        }, completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.middleFilledWidth.constant = 34.scale
            
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
            })
        })
    }
}

// MARK: Private
private extension OQuizResultView {
    func initialize() {
        backgroundColor = Appearance.main100
        
        beginnerProgressView.backgroundColor = Appearance.main300.withAlphaComponent(0.1)
        beginnerFilledProgressView.backgroundColor = Appearance.main300
        middleProgressView.backgroundColor = Appearance.main300.withAlphaComponent(0.1)
        middleFilledProgressView.backgroundColor = Appearance.main300
        advancedProgressView.backgroundColor = Appearance.main300.withAlphaComponent(0.1)
        
        beginnerProgressView.layer.cornerRadius = 8.scale
        beginnerProgressView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        beginnerFilledProgressView.layer.cornerRadius = 8.scale
        beginnerFilledProgressView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        advancedProgressView.layer.cornerRadius = 8.scale
        advancedProgressView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        let selectedProgressAttrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.Inter.semiBold(size: 15.scale))
            .lineHeight(18.scale)
            .letterSpacing(-0.44.scale)
        beginnerProgressLabel.attributedText = "Onboarding.QuizResult.Level1".localized.attributed(with: selectedProgressAttrs)
        middleProgressLabel.attributedText = "Onboarding.QuizResult.Level2".localized.attributed(with: selectedProgressAttrs)
        
        let deselectedProgressAttrs = TextAttributes()
            .textColor(Appearance.mono300.withAlphaComponent(0.4))
            .font(Fonts.Inter.semiBold(size: 15.scale))
            .lineHeight(18.scale)
            .letterSpacing(-0.44.scale)
        advancedProgressLabel.attributedText = "Onboarding.QuizResult.Level3".localized.attributed(with: deselectedProgressAttrs)
    }
}

// MARK: Make constraints
private extension OQuizResultView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 94.scale : 34.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            cursorView.widthAnchor.constraint(equalToConstant: 30.62.scale),
            cursorView.heightAnchor.constraint(equalToConstant: 24.scale),
            cursorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 152.5.scale),
            cursorView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 33.scale)
        ])
        
        NSLayoutConstraint.activate([
            beginnerProgressView.widthAnchor.constraint(equalToConstant: 108.scale),
            beginnerProgressView.heightAnchor.constraint(equalToConstant: 23.scale),
            beginnerProgressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            beginnerProgressView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 65.scale)
        ])
        
        beginnerFilledWidth = beginnerFilledProgressView.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            beginnerFilledWidth,
            beginnerFilledProgressView.heightAnchor.constraint(equalToConstant: 23.scale),
            beginnerFilledProgressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            beginnerFilledProgressView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 65.scale)
        ])
        
        NSLayoutConstraint.activate([
            middleProgressView.widthAnchor.constraint(equalToConstant: 108.scale),
            middleProgressView.heightAnchor.constraint(equalToConstant: 23.scale),
            middleProgressView.leadingAnchor.constraint(equalTo: beginnerProgressView.trailingAnchor, constant: 6.scale),
            middleProgressView.centerYAnchor.constraint(equalTo: beginnerProgressView.centerYAnchor)
        ])
        
        middleFilledWidth = middleFilledProgressView.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            middleFilledWidth,
            middleFilledProgressView.heightAnchor.constraint(equalToConstant: 23.scale),
            middleFilledProgressView.leadingAnchor.constraint(equalTo: beginnerProgressView.trailingAnchor, constant: 6.scale),
            middleFilledProgressView.centerYAnchor.constraint(equalTo: beginnerProgressView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            advancedProgressView.widthAnchor.constraint(equalToConstant: 108.scale),
            advancedProgressView.heightAnchor.constraint(equalToConstant: 23.scale),
            advancedProgressView.leadingAnchor.constraint(equalTo: middleProgressView.trailingAnchor, constant: 5.scale),
            advancedProgressView.centerYAnchor.constraint(equalTo: beginnerProgressView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            beginnerProgressLabel.leadingAnchor.constraint(equalTo: beginnerProgressView.leadingAnchor),
            beginnerProgressLabel.topAnchor.constraint(equalTo: beginnerProgressView.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            middleProgressLabel.leadingAnchor.constraint(equalTo: middleProgressView.leadingAnchor),
            middleProgressLabel.topAnchor.constraint(equalTo: middleProgressView.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            advancedProgressLabel.leadingAnchor.constraint(equalTo: advancedProgressView.leadingAnchor),
            advancedProgressLabel.topAnchor.constraint(equalTo: advancedProgressView.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            button.heightAnchor.constraint(equalToConstant: 48.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OQuizResultView {
    func makeHeaderLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.Inter.bold(size: 17.scale))
            .lineHeight(20.4.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.QuizResult.Header".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 28.scale))
            .lineHeight(33.6.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.QuizResult.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono300)
            .font(Fonts.Inter.regular(size: 15.scale))
            .lineHeight(22.5.scale)
            .letterSpacing(-0.14.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.QuizResult.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCursorView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "OQuizResult.Cursor")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .letterSpacing(-0.44.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Onboarding.QuizResult.Button".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 8.scale
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
