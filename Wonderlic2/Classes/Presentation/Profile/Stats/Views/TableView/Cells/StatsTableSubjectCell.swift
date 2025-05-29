//
//  StatsTableSubjectCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 03.06.2022.
//

import UIKit

final class StatsTableSubjectCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var nameLabel = makeLabel()
    lazy var rateLabel = makeLabel()
    lazy var progressView = makeProgressView()
    lazy var correctLabel = makeLabel()
    
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
extension StatsTableSubjectCell {
    func setup(element: SubjectProgress) {
        nameLabel.attributedText = element.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.mono200)
                            .font(Fonts.Inter.regular(size: 15.scale))
                            .lineHeight(22.5.scale)
                            .letterSpacing(-0.14.scale))
        
        rateLabel.attributedText = String(format: "%i%%", element.rate)
            .attributed(with: TextAttributes()
                            .textColor(Appearance.mono200)
                            .font(Fonts.Inter.bold(size: 24.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.44.scale))
        
        progressView.progress = Float(element.rate) / 100
        
        correctLabel.attributedText = String(format: "Stats.Subject.Correct".localized, element.answeredCount, element.totalCount)
            .attributed(with: TextAttributes()
                .textColor(Appearance.main200)
                            .font(Fonts.Inter.regular(size: 14.scale))
                            .lineHeight(19.6.scale)
                            .letterSpacing(-0.14.scale))
    }
}

// MARK: Private
private extension StatsTableSubjectCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension StatsTableSubjectCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            rateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            rateLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 65.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            progressView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            progressView.heightAnchor.constraint(equalToConstant: 9.scale),
            progressView.topAnchor.constraint(equalTo: container.topAnchor, constant: 101.scale)
        ])
        
        NSLayoutConstraint.activate([
            correctLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            correctLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 118.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension StatsTableSubjectCell {
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
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.layer.cornerRadius = 4.5.scale
        view.layer.masksToBounds = true
        view.trackTintColor = Appearance.main100
        view.progressTintColor = Appearance.main500
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
