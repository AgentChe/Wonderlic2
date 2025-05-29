//
//  StepTestProgressView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 12.05.2022.
//

import UIKit

final class StepTestProgressView: UIView {
    lazy var column1 = makeColumn()
    lazy var column2 = makeColumn()
    lazy var column3 = makeColumn()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension StepTestProgressView {
    func setup(progress: Int) {
        clear()
        fill(at: progress)
    }
}

// MARK: Private
private extension StepTestProgressView {
    func clear() {
        [column1, column2, column3].forEach { $0.backgroundColor = Appearance.main200 }
    }
    
    func fill(at progress: Int) {
        let color = filledColor(at: progress)
        
        var columns = [UIView]()
        
        if progress == 0 {
            columns = []
        } else if progress <= 33 {
            columns = [column1]
        } else if progress <= 66 {
            columns = [column1, column2]
        } else {
            columns = [column1, column2, column3]
        }
        
        columns.forEach { $0.backgroundColor = color }
    }
    
    func filledColor(at progress: Int) -> UIColor {
        progress <= 33 ? Appearance.system100 : Appearance.system200
    }
}

// MARK: Make constraints
private extension StepTestProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            column1.widthAnchor.constraint(equalToConstant: 4.5.scale),
            column1.heightAnchor.constraint(equalToConstant: 6.75.scale),
            column1.bottomAnchor.constraint(equalTo: bottomAnchor),
            column1.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            column2.widthAnchor.constraint(equalToConstant: 4.5.scale),
            column2.heightAnchor.constraint(equalToConstant: 12.38.scale),
            column2.bottomAnchor.constraint(equalTo: bottomAnchor),
            column2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6.75.scale)
        ])
        
        NSLayoutConstraint.activate([
            column3.widthAnchor.constraint(equalToConstant: 4.5.scale),
            column3.heightAnchor.constraint(equalToConstant: 15.75.scale),
            column3.bottomAnchor.constraint(equalTo: bottomAnchor),
            column3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13.5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension StepTestProgressView {
    func makeColumn() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 1.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
