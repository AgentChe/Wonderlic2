//
//  StatsMainProgressView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 03.06.2022.
//

import UIKit

final class StatsMainProgressView: UIView {
    private lazy var totalLayer = CAShapeLayer()
    private lazy var answeredLayer = CAShapeLayer()
    private lazy var correctLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 122.scale, height: 122.scale)
    }
}

// MARK: Public
extension StatsMainProgressView {
    func setup(answered: Int, correct: Int) {
        answeredLayer.strokeEnd = CGFloat(answered) / 100
        correctLayer.strokeEnd = CGFloat(correct) / 100
    }
}

// MARK: Private
private extension StatsMainProgressView {
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: intrinsicContentSize.width / 2,
                                                           y: intrinsicContentSize.height / 2),
                                        radius: 54.scale,
                                        startAngle: -.pi / 2,
                                        endAngle: 1.5 * .pi,
                                        clockwise: true)
        
        totalLayer.path = circularPath.cgPath
        totalLayer.fillColor = UIColor.clear.cgColor
        totalLayer.lineCap = .round
        totalLayer.lineWidth = 14.scale
        totalLayer.strokeColor = Appearance.main100.cgColor
        
        answeredLayer.path = circularPath.cgPath
        answeredLayer.fillColor = UIColor.clear.cgColor
        answeredLayer.lineCap = .round
        answeredLayer.lineWidth = 14.scale
        answeredLayer.strokeColor = Appearance.main500.cgColor
        answeredLayer.strokeStart = 0
        
        correctLayer.path = circularPath.cgPath
        correctLayer.fillColor = UIColor.clear.cgColor
        correctLayer.lineCap = .round
        correctLayer.lineWidth = 14.scale
        correctLayer.strokeColor = Appearance.system200.cgColor
        correctLayer.strokeStart = 0
        
        layer.addSublayer(totalLayer)
        layer.addSublayer(answeredLayer)
        layer.addSublayer(correctLayer)
    }
}
