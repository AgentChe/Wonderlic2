//
//  PaygateView.swift
//  CodeChallenge
//
//  Created by Андрей Чернышев on 20.02.2024.
//

import UIKit

final class PaygateView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(number: 1)
    lazy var cell2 = makeCell(number: 2)
    lazy var cell3 = makeCell(number: 3)
    lazy var lifetimeButton = makeLifetimeButton()
    lazy var subscriptionButton = makeSubscriptionButton()
    lazy var buyButton = makeBuyButton()
    lazy var cancelAnytimeLabel = makeCancelAnytimeLabel()
    lazy var actionsView = makeActionsView()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension PaygateView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension PaygateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 230.scale : 167.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 16.scale : 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 7.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 7.scale)
        ])
        
        NSLayoutConstraint.activate([
            lifetimeButton.widthAnchor.constraint(equalToConstant: 161.scale),
            lifetimeButton.heightAnchor.constraint(equalToConstant: 185.scale),
            lifetimeButton.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 24.scale : 12.scale),
            lifetimeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            subscriptionButton.widthAnchor.constraint(equalToConstant: 161.scale),
            subscriptionButton.heightAnchor.constraint(equalToConstant: 185.scale),
            subscriptionButton.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 24.scale : 12.scale),
            subscriptionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            buyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 29.scale),
            buyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -29.scale),
            buyButton.topAnchor.constraint(equalTo: lifetimeButton.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 20.scale : 16.scale),
            buyButton.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            cancelAnytimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cancelAnytimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cancelAnytimeLabel.topAnchor.constraint(equalTo: buyButton.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            actionsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -6.scale),
            actionsView.heightAnchor.constraint(equalToConstant: 22.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 45.scale),
            preloader.heightAnchor.constraint(equalToConstant: 45.scale),
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: buyButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.tintColor = Appearance.mono100
        view.setImage(UIImage(named: "Paygate.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: ScreenSize.isIphoneXFamily ? "Paygate.Image.X" : "Paygate.Image.8")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(29.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 2
        view.attributedText = "Paygate.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(number: Int) -> PaygateInfoCell {
        let view = PaygateInfoCell(text: "Paygate.Info\(number)".localized)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLifetimeButton() -> PaygateLifetimeButton {
        let view = PaygateLifetimeButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubscriptionButton() -> PaygateSubscriptionButton {
        let view = PaygateSubscriptionButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBuyButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 8.scale
        view.backgroundColor = Appearance.main300
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCancelAnytimeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono300)
            .font(Fonts.Inter.medium(size: 14.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.14.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Paygate.CancelAnytime".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeActionsView() -> PaygateActionsView {
        let view = PaygateActionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 32.scale, height: 32.scale), color: .main)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
