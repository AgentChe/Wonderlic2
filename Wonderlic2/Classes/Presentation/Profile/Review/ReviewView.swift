//
//  ReviewView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

import UIKit

final class ReviewView: UIView {
    lazy var filterView = makeFilterView()
    lazy var tableView = makeTableView()
    lazy var emptyView = makeEmptyView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ReviewView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension ReviewView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            filterView.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 31.scale),
            filterView.topAnchor.constraint(equalTo: topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            tableView.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 24.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 44.scale),
            emptyView.heightAnchor.constraint(equalToConstant: 281.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ReviewView {
    func makeFilterView() -> ReviewFilterView {
        let view = ReviewFilterView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> ReviewTableView {
        let view = ReviewTableView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> ReviewEmptyView {
        let view = ReviewEmptyView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
