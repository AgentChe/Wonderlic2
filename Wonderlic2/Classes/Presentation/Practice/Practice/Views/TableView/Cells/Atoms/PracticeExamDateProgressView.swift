//
//  PracticeExamDateProgressView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 16.06.2022.
//

import UIKit

final class PracticeExamDateProgressView: UIView {
    private lazy var trackLayer = CAShapeLayer()
    private lazy var progressLayer = CAShapeLayer()
    private lazy var dotLayer = CAShapeLayer()
    
    private lazy var centerPoint = CGPoint(x: intrinsicContentSize.width / 2,
                                           y: intrinsicContentSize.height / 2)
    private lazy var radius = 97.scale
    private lazy var deviation = Double(15) * .pi / Double(180)
    private lazy var startAngle = -.pi / 2 + deviation
    private lazy var endAngle = 1.5 * .pi - deviation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 224.scale, height: 224.scale)
    }
}

// MARK: Public
extension PracticeExamDateProgressView {
    func setup(progress: Int?) {
        let strokeEnd = CGFloat(progress ?? 0) / 100

        progressLayer.strokeEnd = strokeEnd
        
        dotLayer.isHidden = progress == nil

        let angle = (endAngle - startAngle) * strokeEnd + startAngle
        let point = CGPoint(x: centerPoint.x + radius * CGFloat(cos(angle)),
                            y: centerPoint.y + radius * CGFloat(sin(angle)))
        dotLayer.position = point
    }
}

// MARK: Private
private extension PracticeExamDateProgressView {
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: centerPoint,
                                        radius: radius,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: true)
        
        let dotPath = UIBezierPath(arcCenter: .zero,
                                   radius: 18.scale,
                                   startAngle: -.pi / 2,
                                   endAngle: 1.5 * .pi,
                                   clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        trackLayer.lineWidth = 30.scale
        trackLayer.strokeColor = Appearance.main300.withAlphaComponent(0.1).cgColor

        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 30.scale
        progressLayer.strokeColor = Appearance.main300.cgColor
        progressLayer.strokeStart = 0
        
        dotLayer.path = dotPath.cgPath
        dotLayer.fillColor = Appearance.main300.cgColor
        dotLayer.lineCap = .round
        dotLayer.lineWidth = 3.scale
        dotLayer.strokeColor = Appearance.mono100.cgColor
        
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
        layer.addSublayer(dotLayer)
    }
}
