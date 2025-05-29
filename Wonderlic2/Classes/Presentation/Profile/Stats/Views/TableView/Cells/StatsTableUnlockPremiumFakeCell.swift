//
//  StatsTableUnlockPremiumFakeCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 03.06.2022.
//

import UIKit

final class StatsTableUnlockPremiumFakeCell: UITableViewCell {
    lazy var fakeView = makeFakeView()
    lazy var unlockLabel = makeTextLabel()
    lazy var unlockButton = makeTextPaddingLabel()
    
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
private extension StatsTableUnlockPremiumFakeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension StatsTableUnlockPremiumFakeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            fakeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            fakeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            fakeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            fakeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            unlockLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            unlockLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 158.scale)
        ])
        
        NSLayoutConstraint.activate([
            unlockButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            unlockButton.topAnchor.constraint(equalTo: unlockLabel.bottomAnchor, constant: 24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension StatsTableUnlockPremiumFakeCell {
    func makeFakeView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "Stats.UnlockPremium.Fake")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Stats.UnlockPremiumFake.Text".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTextPaddingLabel() -> PaddingLabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .lineHeight(20.4.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = PaddingLabel()
        view.insets = UIEdgeInsets(top: 14.scale, left: 51.scale, bottom: 14.scale, right: 51.scale)
        view.numberOfLines = 0
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.backgroundColor = Appearance.main300
        view.attributedText = "Stats.UnlockPremiumFake.Button".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
