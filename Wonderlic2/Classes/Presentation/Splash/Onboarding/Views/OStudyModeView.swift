//
//  OStudyModeView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 09.03.2022.
//

import UIKit
import RxSwift

struct OStudyModeElement {
    let name: String
    let text: String
    let code: TestMode
}

protocol OStudyModeViewDelegate: AnyObject {
    func studyModeViewDidSelected(element: OStudyModeElement)
}

final class OStudyModeView: OSlideView {
    weak var studyModeDelegate: OStudyModeViewDelegate?
    
    lazy var headerLabel = makeHeaderLabel()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var cell1 = makeCell(element: OStudyModeElement(name: "Onboarding.StudyMode.Mode1.Title".localized,
                                                         text: "Onboarding.StudyMode.Mode1.Text".localized,
                                                         code: .fullComplect))
    lazy var cell2 = makeCell(element: OStudyModeElement(name: "Onboarding.StudyMode.Mode2.Title".localized,
                                                         text: "Onboarding.StudyMode.Mode2.Text".localized,
                                                         code: .noExplanations))
    lazy var cell3 = makeCell(element: OStudyModeElement(name: "Onboarding.StudyMode.Mode3.Title".localized,
                                                         text: "Onboarding.StudyMode.Mode3.Text".localized,
                                                         code: .onAnExam))
    lazy var button = makeButton()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        changeEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OStudyModeView {
    func initialize() {
        backgroundColor = Appearance.main100
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                guard let element = [self.cell1, self.cell2, self.cell3].first(where: { $0.isChecked })?.element else {
                    return
                }
                
                self.studyModeDelegate?.studyModeViewDidSelected(element: element)
                
                self.onNext()
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func tapped(sender: UIButton) {
        guard let studyModeButton = sender as? OStudyModeCell else {
            return
        }
        
        [cell1, cell2, cell3].forEach { $0.isChecked = false }
        studyModeButton.isChecked = true
        
        changeEnabled()
    }
    
    func changeEnabled() {
        let isChecked = [cell1, cell2, cell3].contains(where: { $0.isChecked })
        
        button.isEnabled = isChecked
        button.alpha = isChecked ? 1 : 0.2
    }
}

// MARK: Make constraints
private extension OStudyModeView {
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
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            cell1.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20.scale),
            cell1.heightAnchor.constraint(equalToConstant: 110.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 16.scale),
            cell2.heightAnchor.constraint(equalToConstant: 110.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 16.scale),
            cell3.heightAnchor.constraint(equalToConstant: 110.scale)
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
private extension OStudyModeView {
    func makeHeaderLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.Inter.bold(size: 17.scale))
            .lineHeight(20.4.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.StudyMode.Header".localized.attributed(with: attrs)
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
        view.attributedText = "Onboarding.StudyMode.Title".localized.attributed(with: attrs)
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
        view.attributedText = "Onboarding.StudyMode.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(element: OStudyModeElement) -> OStudyModeCell {
        let view = OStudyModeCell()
        view.isChecked = false
        view.element = element
        view.backgroundColor = UIColor.clear
        view.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
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
        view.setAttributedTitle("Next".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension TestMode {
    var analytics: String {
        switch self {
        case .fullComplect:
            return "full support"
        case .noExplanations:
            return "without explanations"
        case .onAnExam:
            return "exam style"
        }
    }
}
