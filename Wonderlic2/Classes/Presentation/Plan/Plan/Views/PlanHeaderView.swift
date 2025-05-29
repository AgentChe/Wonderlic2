//
//  PlanHeaderView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 25.04.2022.
//

import UIKit

final class PlanHeaderView: UIView {
    lazy var currentView = makeCurrentView()
    lazy var studyScoreView = makeStudyScoreView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension PlanHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            currentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentView.bottomAnchor.constraint(equalTo: studyScoreView.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            studyScoreView.leadingAnchor.constraint(equalTo: leadingAnchor),
            studyScoreView.trailingAnchor.constraint(equalTo: trailingAnchor),
            studyScoreView.bottomAnchor.constraint(equalTo: bottomAnchor),
            studyScoreView.heightAnchor.constraint(equalToConstant: 68.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PlanHeaderView {
    func makeCurrentView() -> PlanCurrentView {
        let view = PlanCurrentView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStudyScoreView() -> PlanStudyScoreView {
        let view = PlanStudyScoreView()
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 12.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
