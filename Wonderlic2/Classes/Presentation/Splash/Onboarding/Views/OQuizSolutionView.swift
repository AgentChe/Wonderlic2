//
//  OQuizSolutionView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 04.03.2022.
//

import UIKit

protocol OQuizSolutionViewDelegate: AnyObject {
    func quizSolutionDidSkip()
    func quizSolutionDidStart()
}

final class OQuizSolutionView: OSlideView {
    weak var quizSolutionDelegate: OQuizSolutionViewDelegate?
    
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var skipButton = makeSkipButton()
    lazy var startButton = makeStartButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OQuizSolutionView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
    
    @objc
    func didSkip() {
        quizSolutionDelegate?.quizSolutionDidSkip()
    }
    
    @objc
    func didStart() {
        quizSolutionDelegate?.quizSolutionDidStart()
    }
}

// MARK: Make constraints
private extension OQuizSolutionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 109.scale),
            imageView.heightAnchor.constraint(equalToConstant: 100.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 294.scale : 194.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            skipButton.widthAnchor.constraint(equalToConstant: 154.scale),
            skipButton.heightAnchor.constraint(equalToConstant: 48.scale),
            skipButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: skipButton.trailingAnchor, constant: 12.scale),
            startButton.widthAnchor.constraint(equalToConstant: 154.scale),
            startButton.heightAnchor.constraint(equalToConstant: 48.scale),
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OQuizSolutionView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "OQuizSolution.Image")
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
        view.attributedText = "Onboarding.QuizSolution.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSkipButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .letterSpacing(-0.44.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Onboarding.QuizSolution.Skip".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 8.scale
        view.addTarget(self, action: #selector(didSkip), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStartButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .letterSpacing(-0.44.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Onboarding.QuizSolution.Start".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 8.scale
        view.addTarget(self, action: #selector(didStart), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
