//
//  StepCollectionFinalCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 16.05.2022.
//

import UIKit

final class StepCollectionFinalCell: UICollectionViewCell {
    lazy var progressView = makeProgressView()
    lazy var imageView = makeImageView()
    
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
extension StepCollectionFinalCell {
    func setup(progress: Int) {
        progressView.setup(progress: progress)
    }
}

// MARK: Private
private extension StepCollectionFinalCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension StepCollectionFinalCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 136.scale),
            progressView.heightAnchor.constraint(equalToConstant: 136.scale),
            progressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 96.scale),
            imageView.heightAnchor.constraint(equalToConstant: 96.scale),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension StepCollectionFinalCell {
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
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Plan.FinalStep")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
