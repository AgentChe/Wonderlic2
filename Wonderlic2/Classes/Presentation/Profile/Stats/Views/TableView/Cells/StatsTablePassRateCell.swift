//
//  StatsTablePassRateCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 03.06.2022.
//

import UIKit

final class StatsTablePassRateCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var percent100Label = makePercentLabel(text: "Stats.PassRate.100Percent".localized)
    lazy var separator100 = makeSeparator()
    lazy var percent50Label = makePercentLabel(text: "Stats.PassRate.50Percent".localized)
    lazy var separator50 = makeSeparator()
    lazy var percent25Label = makePercentLabel(text: "Stats.PassRate.25Percent".localized)
    lazy var separator25 = makeSeparator()
    lazy var percent0Label = makePercentLabel(text: "Stats.PassRate.0Percent".localized)
    lazy var separator0 = makeSeparator()
    lazy var passRateLabel = makePassRateLabel()
    lazy var dotsView = makeDotsView()
    lazy var progressView = makeProgressView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension StatsTablePassRateCell {
    func setup(element: [PassRateProgress]) {
        progressView.arrangedSubviews.forEach {
            progressView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        element.forEach { passRate in
            let passRateView = StatsPassRateView()
            passRateView.backgroundColor = UIColor.clear
            passRateView.translatesAutoresizingMaskIntoConstraints = false
            passRateView.setup(element: passRate)
            
            progressView.addArrangedSubview(passRateView)
        }
    }
}

// MARK: Private
private extension StatsTablePassRateCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension StatsTablePassRateCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            percent100Label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18.scale),
            percent100Label.topAnchor.constraint(equalTo: container.topAnchor, constant: 52.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator100.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            separator100.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -66.scale),
            separator100.centerYAnchor.constraint(equalTo: percent100Label.centerYAnchor),
            separator100.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
        
        NSLayoutConstraint.activate([
            percent50Label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18.scale),
            percent50Label.topAnchor.constraint(equalTo: container.topAnchor, constant: 132.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator50.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            separator50.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -66.scale),
            separator50.centerYAnchor.constraint(equalTo: percent50Label.centerYAnchor),
            separator50.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
        
        NSLayoutConstraint.activate([
            percent25Label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18.scale),
            percent25Label.topAnchor.constraint(equalTo: container.topAnchor, constant: 172.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator25.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            separator25.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -66.scale),
            separator25.centerYAnchor.constraint(equalTo: percent25Label.centerYAnchor),
            separator25.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
        
        NSLayoutConstraint.activate([
            percent0Label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18.scale),
            percent0Label.topAnchor.constraint(equalTo: container.topAnchor, constant: 212.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator0.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            separator0.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -66.scale),
            separator0.centerYAnchor.constraint(equalTo: percent0Label.centerYAnchor),
            separator0.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
        
        NSLayoutConstraint.activate([
            passRateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18.scale),
            passRateLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            dotsView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            dotsView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18.scale),
            dotsView.topAnchor.constraint(equalTo: container.topAnchor, constant: 96.scale),
            dotsView.heightAnchor.constraint(equalToConstant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            progressView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -80.scale),
            progressView.topAnchor.constraint(equalTo: separator100.bottomAnchor),
            progressView.bottomAnchor.constraint(equalTo: separator0.topAnchor, constant: 29.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension StatsTablePassRateCell {
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
    
    func makePercentLabel(text: String) -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main200)
            .font(Fonts.Inter.regular(size: 14.scale))
            .lineHeight(19.6.scale)
            .letterSpacing(-0.14.scale)
        
        let view = UILabel()
        view.attributedText = text.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main100
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makePassRateLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.Inter.regular(size: 14.scale))
            .lineHeight(19.6.scale)
            .letterSpacing(-0.14.scale)
        
        let view = UILabel()
        view.attributedText = "Stats.PassRate.PassRate".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeDotsView() -> UILabel {
        let view = UILabel()
        view.lineBreakMode = .byCharWrapping
        view.textColor = Appearance.main300
        view.text = "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIStackView {
        let view = UIStackView()
        view.backgroundColor = UIColor.clear
        view.axis = .horizontal
        view.alignment = .fill
        view.spacing = 20.scale
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
