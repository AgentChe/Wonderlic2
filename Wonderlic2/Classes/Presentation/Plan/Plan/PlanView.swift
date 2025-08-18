//
//  PlanView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 30.03.2022.
//

import UIKit

final class PlanView: UIView {
    lazy var headerView = makeHeaderView()
    lazy var stepCollectionView = makeStepCollectionView()
    lazy var stepNameLabel = makeStepNameLabel()
    lazy var testsTableView = makeTestsTableView()
    lazy var finalStepView = makeFinalStepView()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstrainsts()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension PlanView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension PlanView {
    func makeConstrainsts() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 167.scale : 157.scale)
        ])
        
        NSLayoutConstraint.activate([
            stepCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stepCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 40.scale : 16.scale),
            stepCollectionView.heightAnchor.constraint(equalToConstant: 136.scale)
        ])
        
        NSLayoutConstraint.activate([
            stepNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            stepNameLabel.topAnchor.constraint(equalTo: stepCollectionView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 18.scale : 9.scale)
        ])
        
        NSLayoutConstraint.activate([
            testsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            testsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            testsTableView.topAnchor.constraint(equalTo: stepNameLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 40.scale : 16.scale),
            testsTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            finalStepView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            finalStepView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            finalStepView.topAnchor.constraint(equalTo: stepNameLabel.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PlanView {
    func makeHeaderView() -> PlanHeaderView {
        let view = PlanHeaderView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = Appearance.main400
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStepCollectionView() -> StepCollectionView {
        let layout = StepCollectionLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 46.scale
        layout.itemSize = CGSize(width: 136.scale, height: 136.scale)
        
        let view = StepCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStepNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTestsTableView() -> StepTestsTableView {
        let view = StepTestsTableView()
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24.scale, right: 0)
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0.0
        }
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 12.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFinalStepView() -> PlanFinalStepView {
        let view = PlanFinalStepView()
        view.isHidden = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
