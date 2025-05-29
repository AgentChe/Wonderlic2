//
//  PaygateProductButton.swift
//  CodeChallenge
//
//  Created by Андрей Чернышев on 19.03.2024.
//

import UIKit
import RxCocoa

class PaygateProductButton: UIButton {
    protocol Product {
        var iapProduct: IAPProduct { get }
    }
    
    var marked: Bool = false {
        didSet {
            update()
        }
    }
    
    var product: Product?
    
    lazy var markedView = makeMarkedView()
    
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
private extension PaygateProductButton {
    func initialize() {
        layer.cornerRadius = 10.scale
        layer.borderWidth = 2.scale
    }
    
    func update() {
        layer.borderColor = marked ? Appearance.main300.cgColor : Appearance.mono200.cgColor
        markedView.isHidden = !marked
        backgroundColor = marked ? Appearance.mono100 : UIColor.clear
    }
}

// MARK: Make constraints
private extension PaygateProductButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            markedView.widthAnchor.constraint(equalToConstant: 24.scale),
            markedView.heightAnchor.constraint(equalToConstant: 24.scale),
            markedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.scale),
            markedView.topAnchor.constraint(equalTo: topAnchor, constant: 10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateProductButton {
    func makeMarkedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Paygate.Checked")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
