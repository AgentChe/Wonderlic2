//
//  TestStatsAnswerContainer.swift
//  ITExams
//
//  Created by Андрей Чернышев on 09.06.2022.
//

import UIKit

final class TestStatsAnswerContainer: UIView {
    enum Side {
        case all, leftRightTop, leftRightBottom, leftRight
    }
    
    private var side = Side.all
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateShadow()
    }
    
    func update(side: Side) {
        self.side = side
        
        updateShadow()
    }
}

// MARK: Private
private extension TestStatsAnswerContainer {
    func initialize() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = .zero
        layer.shadowRadius = 6.scale
    }
    
    func updateShadow() {
        let rect: CGRect
        
        switch side {
        case .all:
            rect = bounds
        case .leftRightTop:
            rect = bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 6.scale, right: 0))
        case .leftRightBottom:
            rect = bounds.inset(by: UIEdgeInsets(top: 6.scale, left: 0, bottom: 0, right: 0))
        case .leftRight:
            rect = bounds.inset(by: UIEdgeInsets(top: 6.scale, left: 0, bottom: 6.scale, right: 0))
        }
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius)
        layer.shadowPath = path.cgPath
    }
}
