//
//  StatsPassRateView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 03.06.2022.
//

import UIKit

final class StatsPassRateView: UIView {
    lazy var dateLabel = makeDateLabel()
    lazy var progressView = makeProgressView()
    
    private lazy var progressHeightConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 40.scale, height: 189.scale)
    }
}

// MARK: Public
extension StatsPassRateView {
    func setup(element: PassRateProgress) {
        let attrs = TextAttributes()
            .textColor(Appearance.mono300)
            .font(Fonts.Inter.regular(size: 12.scale))
            .lineHeight(16.8.scale)
            .letterSpacing(-0.14.scale)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        
        dateLabel.attributedText = formatter.string(from: element.date).attributed(with: attrs)
        
        progressHeightConstraint.isActive = false
        progressHeightConstraint.constant = 160.scale / 100 * CGFloat(element.rate)
        progressHeightConstraint.isActive = true
        
        layoutIfNeeded()
    }
}

// MARK: Make constraints
private extension StatsPassRateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        progressHeightConstraint = progressView.heightAnchor.constraint(equalToConstant: 160.scale)
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.widthAnchor.constraint(equalToConstant: 8.scale),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -29.scale),
            progressHeightConstraint
        ])
    }
}

// MARK: Lazy initialization
private extension StatsPassRateView {
    func makeDateLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
