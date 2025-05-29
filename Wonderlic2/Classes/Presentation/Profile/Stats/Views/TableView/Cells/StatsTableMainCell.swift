//
//  StatsTableMainCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 03.06.2022.
//

import UIKit

final class StatsTableMainCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var progressView = makeProgressView()
    lazy var progressLabel = makeLabel()
    lazy var answeredIndicatorView = makeIndicatorView(color: Appearance.main500)
    lazy var answeredPlaceholderLabel = makePlaceholderLabel(text: "Stats.Main.Answered".localized)
    lazy var answeredValueLabel = makeLabel()
    lazy var correctIndicatorView = makeIndicatorView(color: Appearance.system200)
    lazy var correctPlaceholderLabel = makePlaceholderLabel(text: "Stats.Main.Correct".localized)
    lazy var correctValueLabel = makeLabel()
    lazy var totalIndicatorView = makeIndicatorView(color: Appearance.main200)
    lazy var totalPlaceholderLabel = makePlaceholderLabel(text: "Stats.Main.Total".localized)
    lazy var totalValueLabel = makeLabel()
    
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
extension StatsTableMainCell {
    func setup(element: StatsTableMain) {
        progressView.setup(answered: element.answeredPercent,
                           correct: element.correctPercent)
        
        progressLabel.attributedText = String(format: "%i%%", element.answeredPercent)
            .attributed(with: TextAttributes()
                            .textColor(Appearance.mono200)
                            .font(Fonts.Inter.bold(size: 30.scale))
                            .lineHeight(36.scale)
                            .letterSpacing(-0.44.scale))
        
        let valueAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.44.scale)
        
        answeredValueLabel.attributedText = String(element.answeredCount).attributed(with: valueAttrs)
        correctValueLabel.attributedText = String(element.correctCount).attributed(with: valueAttrs)
        totalValueLabel.attributedText = String(element.totalCount).attributed(with: valueAttrs)
    }
}

// MARK: Private
private extension StatsTableMainCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension StatsTableMainCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 17.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            answeredIndicatorView.widthAnchor.constraint(equalToConstant: 16.scale),
            answeredIndicatorView.heightAnchor.constraint(equalToConstant: 6.scale),
            answeredIndicatorView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 156.scale),
            answeredIndicatorView.topAnchor.constraint(equalTo: container.topAnchor, constant: 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            answeredPlaceholderLabel.leadingAnchor.constraint(equalTo: answeredIndicatorView.trailingAnchor, constant: 8.scale),
            answeredPlaceholderLabel.centerYAnchor.constraint(equalTo: answeredIndicatorView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            answeredValueLabel.leadingAnchor.constraint(equalTo: answeredIndicatorView.trailingAnchor, constant: 92.scale),
            answeredValueLabel.centerYAnchor.constraint(equalTo: answeredIndicatorView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            correctIndicatorView.widthAnchor.constraint(equalToConstant: 16.scale),
            correctIndicatorView.heightAnchor.constraint(equalToConstant: 6.scale),
            correctIndicatorView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 156.scale),
            correctIndicatorView.topAnchor.constraint(equalTo: container.topAnchor, constant: 83.scale)
        ])
        
        NSLayoutConstraint.activate([
            correctPlaceholderLabel.leadingAnchor.constraint(equalTo: correctIndicatorView.trailingAnchor, constant: 8.scale),
            correctPlaceholderLabel.centerYAnchor.constraint(equalTo: correctIndicatorView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            correctValueLabel.leadingAnchor.constraint(equalTo: correctIndicatorView.trailingAnchor, constant: 92.scale),
            correctValueLabel.centerYAnchor.constraint(equalTo: correctIndicatorView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            totalIndicatorView.widthAnchor.constraint(equalToConstant: 16.scale),
            totalIndicatorView.heightAnchor.constraint(equalToConstant: 6.scale),
            totalIndicatorView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 156.scale),
            totalIndicatorView.topAnchor.constraint(equalTo: container.topAnchor, constant: 122.scale)
        ])
        
        NSLayoutConstraint.activate([
            totalPlaceholderLabel.leadingAnchor.constraint(equalTo: totalIndicatorView.trailingAnchor, constant: 8.scale),
            totalPlaceholderLabel.centerYAnchor.constraint(equalTo: totalIndicatorView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            totalValueLabel.leadingAnchor.constraint(equalTo: totalIndicatorView.trailingAnchor, constant: 92.scale),
            totalValueLabel.centerYAnchor.constraint(equalTo: totalIndicatorView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension StatsTableMainCell {
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
    
    func makeProgressView() -> StatsMainProgressView {
        let view = StatsMainProgressView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeIndicatorView(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 3.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makePlaceholderLabel(text: String) -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono300)
            .font(Fonts.Inter.regular(size: 15.scale))
            .lineHeight(22.5.scale)
            .letterSpacing(-0.14.scale)
        
        let view = UILabel()
        view.attributedText = text.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
