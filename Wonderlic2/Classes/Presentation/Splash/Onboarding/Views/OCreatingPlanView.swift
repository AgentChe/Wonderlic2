//
//  OPlanView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 09.03.2022.
//

import UIKit

final class OCreatingPlanView: OSlideView {
    weak var combineData: OnboardingCombineData?
    
    lazy var titleLabel = makeTitleLabel()
    
    private lazy var sections = [OCreatingPlanSectionView]()
    
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
        
        guard let data = combineData?.combineData() else {
            return
        }
        
        clear()
        configure(data: data)
        openUpSection { [weak self] in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.onNext()
            }
        }
        
        RequestReview.request()
    }
}

// MARK: Private
private extension OCreatingPlanView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
    
    func clear() {
        sections.forEach { $0.removeFromSuperview() }
        sections = []
    }
    
    func configure(data: OCombineData) {
        let goalsSectionView = OCreatingPlanSectionView(title: "Onboarding.CreatingPlanView.Section1".localized,
                                                        rows: [data.motivation.title])
        let personalDataSectionView = OCreatingPlanSectionView(title: "Onboarding.CreatingPlanView.Section2".localized,
                                                               rows: [data.age])
        let examDetailsSectionView = OCreatingPlanSectionView(title: "Onboarding.CreatingPlanView.Section3".localized,
                                                              rows: [data.course.name,
                                                                     examDateFormatted(data.examDate)
                                                                    ].compactMap { $0 })
        let studyPreferences = OCreatingPlanSectionView(title: "Onboarding.CreatingPlanView.Section4".localized,
                                                        rows: ["Onboarding.CreatingPlanView.DailyGoal".localized, data.studyMode.name])
        
        let views = [
            goalsSectionView,
            personalDataSectionView,
            examDetailsSectionView,
            studyPreferences
        ]
        
        views.enumerated().forEach { index, view in
            view.backgroundColor = UIColor.clear
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            
            let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor)
            let trailing = view.trailingAnchor.constraint(equalTo: trailingAnchor)
            [leading, trailing].forEach { $0.isActive = true }
            
            if index == 0 {
                let top = view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 26.scale)
                top.isActive = true
            } else if let previousView = sections.last {
                let top = view.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 26.scale)
                top.isActive = true
            }
            
            view.hide()
            
            sections.append(view)
        }
    }
    
    func openUpSection(index: Int = 0, completion: @escaping () -> Void) {
        guard sections.indices.contains(index) else {
            completion()
            return
        }
        
        sections[index].openUp { [weak self] in
            guard let self = self else {
                return
            }
            
            self.openUpSection(index: index + 1, completion: completion)
        }
    }
    
    func examDateFormatted(_ date: Date?) -> String? {
        guard let date = date else {
            return nil
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}

// MARK: Make constraints
private extension OCreatingPlanView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 94.scale : 34.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OCreatingPlanView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 28.scale))
            .lineHeight(33.6.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.CreatingPlanView.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
