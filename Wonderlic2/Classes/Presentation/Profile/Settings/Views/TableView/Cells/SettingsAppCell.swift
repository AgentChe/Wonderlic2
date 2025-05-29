//
//  SettingsAppCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 13.05.2022.
//

import UIKit
import RxSwift
import StoreKit

final class SettingsAppCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var contactUsButton = makeButton(title: "Settings.ContactUs".localized, withSeparator: true)
    lazy var privacyPolicyButton = makeButton(title: "Settings.PrivacyPolicy".localized, withSeparator: true)
    lazy var termsOfUseButton = makeButton(title: "Settings.TermsOfUse".localized, withSeparator: true)
    lazy var rateUsButton = makeButton(title: "Settings.RateUs".localized, withSeparator: false)
    
    private lazy var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SettingsAppCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none

        Observable
            .merge(
                contactUsButton.rx.tap
                    .map { GlobalDefinitions.contactUsUrl },
                privacyPolicyButton.rx.tap
                    .map { GlobalDefinitions.privacyPolicyUrl },
                termsOfUseButton.rx.tap
                    .map { GlobalDefinitions.termsOfServiceUrl }
            )
            .subscribe(onNext: { url in
                UIApplication.shared.open(url, options: [:])
            })
            .disposed(by: disposeBag)
        
        rateUsButton.rx.tap
            .subscribe(onNext: {
                SKStoreReviewController.requestReview()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension SettingsAppCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contactUsButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            contactUsButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            contactUsButton.heightAnchor.constraint(equalToConstant: 64.scale),
            contactUsButton.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            privacyPolicyButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            privacyPolicyButton.heightAnchor.constraint(equalToConstant: 64.scale),
            privacyPolicyButton.topAnchor.constraint(equalTo: contactUsButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            termsOfUseButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            termsOfUseButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            termsOfUseButton.heightAnchor.constraint(equalToConstant: 64.scale),
            termsOfUseButton.topAnchor.constraint(equalTo: privacyPolicyButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rateUsButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            rateUsButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            rateUsButton.heightAnchor.constraint(equalToConstant: 64.scale),
            rateUsButton.topAnchor.constraint(equalTo: termsOfUseButton.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsAppCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeButton(title: String, withSeparator: Bool) -> SettingsAppButton {
        let view = SettingsAppButton(title: title, withSeparator: withSeparator)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
