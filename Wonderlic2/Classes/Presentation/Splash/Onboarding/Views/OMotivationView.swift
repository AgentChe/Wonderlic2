//
//  OMotivationView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 01.03.2022.
//

import UIKit
import RxSwift

struct OMotivationElement {
    let title: String
    let icon: UIImage
    let code: Int
}

protocol OMotivationViewDelegate: AnyObject {
    func motivationViewDidSelected(element: OMotivationElement)
}

final class OMotivationView: OSlideView {
    weak var motivationDelegate: OMotivationViewDelegate?
    
    lazy var headerLabel = makeHeaderLabel()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var cell1 = makeCell1()
    lazy var cell2 = makeCell2()
    lazy var cell3 = makeCell3()
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
private extension OMotivationView {
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
                
                self.motivationDelegate?.motivationViewDidSelected(element: element)
                
                self.onNext()
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func tapped(sender: UIButton) {
        guard let cell = sender as? OMotivationCell else {
            return
        }
        
        [cell1, cell2, cell3].forEach { $0.isChecked = false }
        cell.isChecked = true
        
        changeEnabled()
    }
    
    func changeEnabled() {
        let isChecked = [cell1, cell2, cell3].contains(where: { $0.isChecked })
        
        button.isEnabled = isChecked
        button.alpha = isChecked ? 1 : 0.2
    }
}

// MARK: Make constraints
private extension OMotivationView {
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
            cell1.heightAnchor.constraint(equalToConstant: 84.scale),
            cell1.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            cell2.heightAnchor.constraint(equalToConstant: 84.scale),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            cell3.heightAnchor.constraint(equalToConstant: 84.scale),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 16.scale)
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
private extension OMotivationView {
    func makeHeaderLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.Inter.bold(size: 17.scale))
            .lineHeight(20.4.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Motivation.Header".localized.attributed(with: attrs)
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
        view.attributedText = "Onboarding.Motivation.Title".localized.attributed(with: attrs)
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
        view.attributedText = "Onboarding.Motivation.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell1() -> OMotivationCell {
        let view = OMotivationCell(iconWidth: 115.scale,
                                   iconHeight: 75.scale,
                                   iconTop: 9.scale)
        view.element = OMotivationElement(title: "Onboarding.Motivation.Cell1".localized,
                                          icon: UIImage(named: "OMotivation.Image1")!,
                                          code: 0)
        view.layer.cornerRadius = 12.scale
        view.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell2() -> OMotivationCell {
        let view = OMotivationCell(iconWidth: 110.scale,
                                   iconHeight: 84.scale,
                                   iconTop: 0)
        view.element = OMotivationElement(title: "Onboarding.Motivation.Cell2".localized,
                                          icon: UIImage(named: "OMotivation.Image2")!,
                                          code: 1)
        view.layer.cornerRadius = 12.scale
        view.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell3() -> OMotivationCell {
        let view = OMotivationCell(iconWidth: 142.scale,
                                   iconHeight: 84.scale,
                                   iconTop: 0)
        view.element = OMotivationElement(title: "Onboarding.Motivation.Cell3".localized,
                                          icon: UIImage(named: "OMotivation.Image3")!,
                                          code: 2)
        view.layer.cornerRadius = 12.scale
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
