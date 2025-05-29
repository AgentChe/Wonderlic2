//
//  ODetermingSkillView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 07.03.2022.
//

import UIKit

final class ODetermingSkillView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var progressView = makeProgressView()
    lazy var percentLabel = makePercentLabel()
    
    private var timer: Timer?
    
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
        
        progressView.progressAnimation(duration: 4.5)
        calculatePercent()
    }
}

// MARK: Private
private extension ODetermingSkillView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
    
    func calculatePercent() {
        let duration = Double(4.5)
        var seconds = Double(0)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            seconds += 0.1
            
            var percent = Int(seconds / duration * 100)
            if percent > 100 {
                percent = 100
            }
            self?.update(percent: percent)
            
            if seconds >= duration {
                timer.invalidate()
                
                self?.finish()
            }
        }
    }
    
    func update(percent: Int) {
        let attrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.Inter.bold(size: 48.scale))
            .lineHeight(57.6.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        percentLabel.attributedText = "\(percent)%".attributed(with: attrs)
    }
    
    func finish() {
        timer = nil
        
        onNext()
    }
}

// MARK: Make constraints
private extension ODetermingSkillView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 94.scale : 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 56.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -56.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 191.scale),
            progressView.heightAnchor.constraint(equalToConstant: 191.scale),
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 125.scale)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ODetermingSkillView {
    func makeProgressView() -> OProgressView {
        let view = OProgressView()
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
        view.attributedText = "Onboarding.DetermingSkill.Title".localized.attributed(with: attrs)
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
        view.attributedText = "Onboarding.DetermingSkill.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePercentLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
