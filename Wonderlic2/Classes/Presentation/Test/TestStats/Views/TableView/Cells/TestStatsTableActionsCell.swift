//
//  TestStatsTableActionsCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import UIKit

final class TestStatsTableActionsCell: UITableViewCell {
    weak var mainDelegate: TestStatsTableViewDelegate?
    
    lazy var restartButton = makeRestartButton()
    lazy var nextTestButton = makeNextTestButton()
    
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
private extension TestStatsTableActionsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func tappedRestart() {
        mainDelegate?.testStatsTableDidTappedRestart()
    }
    
    @objc
    func tappedNextTest() {
        mainDelegate?.testStatsTableDidTappedNextTest()
    }
}

// MARK: Make constraints
private extension TestStatsTableActionsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            restartButton.widthAnchor.constraint(equalToConstant: 135.scale),
            restartButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            restartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            restartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextTestButton.widthAnchor.constraint(equalToConstant: 171.scale),
            nextTestButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            nextTestButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nextTestButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 175.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsTableActionsCell {
    func makeRestartButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .letterSpacing(-0.44.scale)
        
        let view = UIButton()
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 8.scale
        view.setAttributedTitle("TestStats.Restart".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(tappedRestart), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNextTestButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .letterSpacing(-0.44.scale)
        
        let view = UIButton()
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 8.scale
        view.setAttributedTitle("TestStats.NextTest".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(tappedNextTest), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
