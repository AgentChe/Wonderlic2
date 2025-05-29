//
//  TestStatsTableProgressCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import UIKit

final class TestStatsTableProgressCell: UITableViewCell {
    lazy var progressView = makeProgressView()
    lazy var progressLabel = makeProgressLabel()
    
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
extension TestStatsTableProgressCell {
    func setup(element: Int) {
        progressView.setup(progress: element)
        
        let color = element < 80 ? Appearance.system100 : Appearance.system200
        progressView.update(circleColor: color.withAlphaComponent(0.2))
        progressView.update(trackColor: color)
        
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 48.scale))
            .lineHeight(58.scale)
            .letterSpacing(-0.44.scale)
        let string = String(format: "%i%%", element)
        progressLabel.attributedText = string.attributed(with: attrs)
    }
}

// MARK: Private
private extension TestStatsTableProgressCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TestStatsTableProgressCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 184.scale),
            progressView.heightAnchor.constraint(equalToConstant: 184.scale),
            progressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsTableProgressCell {
    func makeProgressView() -> CircleProgressView {
        let view = CircleProgressView(arcCenter: CGPoint(x: 92.scale, y: 92.scale),
                                      radius: 82.scale,
                                      lineWidth: 20.scale,
                                      circleColor: Appearance.system200.withAlphaComponent(0.2),
                                      trackColor: Appearance.system200)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeProgressLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
