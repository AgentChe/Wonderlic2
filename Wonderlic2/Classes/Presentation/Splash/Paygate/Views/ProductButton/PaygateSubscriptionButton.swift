//
//  PaygateSubscriptionButton.swift
//  EMT2thdplatform
//
//  Created by Андрей Чернышев on 28.03.2025.
//

import UIKit
import OtterScaleiOS

final class PaygateSubscriptionButton: PaygateProductButton {
    struct Product: PaygateProductButton.Product {
        let iapProduct: IAPProduct
        let name: String
        let price: String
        let period: String
        let bottomInfo: String
    }
    
    lazy var nameLabel = makeLabel()
    lazy var priceLabel = makeLabel()
    lazy var bottomInfoLabel = makeLabel()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Inter.bold(size: 20.scale))
        .lineHeight(24.scale)
        .letterSpacing(-0.44.scale)
        .textAlignment(.left)
    private lazy var priceAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Inter.semiBold(size: 22.scale))
        .lineHeight(31.scale)
        .letterSpacing(-0.44.scale)
        .textAlignment(.left)
    private lazy var periodAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Inter.medium(size: 12.scale))
        .lineHeight(31.scale)
        .letterSpacing(-0.14.scale)
        .textAlignment(.left)
    private lazy var bottomInfoAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Inter.medium(size: 12.scale))
        .lineHeight(17.scale)
        .letterSpacing(-0.14.scale)
        .textAlignment(.left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PaygateSubscriptionButton {
    func setup(product: Product) {
        self.product = product
        
        nameLabel.attributedText = product.name.attributed(with: nameAttrs)
        bottomInfoLabel.attributedText = product.bottomInfo.attributed(with: bottomInfoAttrs)
        
        let price: NSAttributedString = {
            let result = NSMutableAttributedString()
            result.append((product.price + "/").attributed(with: priceAttrs))
            result.append(product.period.attributed(with: periodAttrs))
            return result
        }()
        priceLabel.attributedText = price
    }
}

// MARK: Make constraints
private extension PaygateSubscriptionButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 34.scale)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            bottomInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            bottomInfoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateSubscriptionButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
extension PaygateSubscriptionButton.Product {
    static func make(subscriptionIAPProduct: IAPProduct) -> PaygateSubscriptionButton.Product {
        let usedProducts = OtterScale.shared
            .getUsedProducts()
            .map { $0.appleAppStore } ?? []
        let withTrial = !usedProducts.contains(GlobalDefinitions.Paygate.subscription)
        
        let price = Currency(iapProduct: subscriptionIAPProduct).formatted() ?? ""
        
        return PaygateSubscriptionButton.Product(
            iapProduct: subscriptionIAPProduct,
            name: withTrial ? "Paygate.Subscription.Name1".localized : "Paygate.Subscription.Name2".localized,
            price: price,
            period: "Paygate.Subscription.Period".localized,
            bottomInfo: withTrial ? "Paygate.Subscription.Bottom1".localized : "Paygate.Subscription.Bottom2".localized
        )
    }
}
