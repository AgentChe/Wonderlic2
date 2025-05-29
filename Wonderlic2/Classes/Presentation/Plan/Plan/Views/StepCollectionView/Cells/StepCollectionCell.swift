//
//  StepCollectionCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 04.05.2022.
//

import UIKit

final class StepCollectionCell: UICollectionViewCell {
    lazy var progressView = makeProgressView()
    lazy var circleView = makeCircleView()
    lazy var progressLabel = makeLabel()
    lazy var lockView = makeLockView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension StepCollectionCell {
    func setup(progress: Int, locked: Bool) {
        progressView.setup(progress: progress)
        
        let attrs = TextAttributes()
            .textColor(Appearance.main300.withAlphaComponent(0.2))
            .font(Fonts.Inter.bold(size: 28.scale))
            .lineHeight(33.6.scale)
            .letterSpacing(-2.scale)
            .textAlignment(.center)
        let string = String(format: "%i%%", progress)
        progressLabel.attributedText = string.attributed(with: attrs)
        
        lockView.isHidden = !locked
        progressLabel.isHidden = locked
    }
}

// MARK: Private
private extension StepCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension StepCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 136.scale),
            progressView.heightAnchor.constraint(equalToConstant: 136.scale),
            progressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: 96.scale),
            circleView.heightAnchor.constraint(equalToConstant: 96.scale),
            circleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lockView.widthAnchor.constraint(equalToConstant: 25.scale),
            lockView.heightAnchor.constraint(equalToConstant: 32.scale),
            lockView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lockView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension StepCollectionCell {
    func makeProgressView() -> CircleProgressView {
        let view = CircleProgressView(arcCenter: CGPoint(x: 68.scale, y: 68.scale),
                                      radius: 62.scale,
                                      lineWidth: 12.scale,
                                      circleColor: Appearance.main200.withAlphaComponent(0.5),
                                      trackColor: Appearance.main300)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCircleView() -> CircleView {
        let view = CircleView()
        view.backgroundColor = Appearance.main200
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLockView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Plan.Lock")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
