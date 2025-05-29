//
//  OPlanGridView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 10.03.2022.
//

import UIKit

final class OPlanGridView: UIView {
    lazy var percent100Label = makePercentLabel(percent: 100)
    lazy var line1View = makeLineView()
    lazy var percent80Label = makePercentLabel(percent: 80)
    lazy var line2View = makeLineView()
    lazy var percent60Label = makePercentLabel(percent: 60)
    lazy var line3View = makeLineView()
    lazy var percent40Label = makePercentLabel(percent: 40)
    lazy var line4View = makeLineView()
    lazy var percent20Label = makePercentLabel(percent: 20)
    lazy var line5View = makeLineView()
    lazy var percent0Label = makePercentLabel(percent: 0)
    lazy var line6View = makeLineView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension OPlanGridView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            percent100Label.trailingAnchor.constraint(equalTo: line1View.leadingAnchor, constant: -12.scale),
            percent100Label.centerYAnchor.constraint(equalTo: line1View.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            line1View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 68.scale),
            line1View.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            line1View.heightAnchor.constraint(equalToConstant: 1.scale),
            line1View.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            percent80Label.trailingAnchor.constraint(equalTo: line2View.leadingAnchor, constant: -12.scale),
            percent80Label.centerYAnchor.constraint(equalTo: line2View.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            line2View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 68.scale),
            line2View.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            line2View.heightAnchor.constraint(equalToConstant: 1.scale),
            line2View.topAnchor.constraint(equalTo: topAnchor, constant: 38.scale)
        ])
        
        NSLayoutConstraint.activate([
            percent60Label.trailingAnchor.constraint(equalTo: line3View.leadingAnchor, constant: -12.scale),
            percent60Label.centerYAnchor.constraint(equalTo: line3View.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            line3View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 68.scale),
            line3View.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            line3View.heightAnchor.constraint(equalToConstant: 1.scale),
            line3View.topAnchor.constraint(equalTo: topAnchor, constant: 75.scale)
        ])
        
        NSLayoutConstraint.activate([
            percent40Label.trailingAnchor.constraint(equalTo: line4View.leadingAnchor, constant: -12.scale),
            percent40Label.centerYAnchor.constraint(equalTo: line4View.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            line4View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 68.scale),
            line4View.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            line4View.heightAnchor.constraint(equalToConstant: 1.scale),
            line4View.topAnchor.constraint(equalTo: topAnchor, constant: 112.scale)
        ])
        
        NSLayoutConstraint.activate([
            percent20Label.trailingAnchor.constraint(equalTo: line5View.leadingAnchor, constant: -12.scale),
            percent20Label.centerYAnchor.constraint(equalTo: line5View.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            line5View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 68.scale),
            line5View.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            line5View.heightAnchor.constraint(equalToConstant: 1.scale),
            line5View.topAnchor.constraint(equalTo: topAnchor, constant: 149.scale)
        ])
        
        NSLayoutConstraint.activate([
            percent0Label.trailingAnchor.constraint(equalTo: line6View.leadingAnchor, constant: -12.scale),
            percent0Label.centerYAnchor.constraint(equalTo: line6View.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            line6View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 68.scale),
            line6View.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            line6View.heightAnchor.constraint(equalToConstant: 1.scale),
            line6View.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OPlanGridView {
    func makePercentLabel(percent: Int) -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.4))
            .font(Fonts.Inter.regular(size: 14.scale))
            .lineHeight(19.6.scale)
            .letterSpacing(-0.14.scale)
        
        let string = String(format: "%i%%", percent)
        
        let view = UILabel()
        view.attributedText = string.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono300.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
