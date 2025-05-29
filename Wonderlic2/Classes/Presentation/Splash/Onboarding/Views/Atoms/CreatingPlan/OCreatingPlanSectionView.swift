//
//  OPlanSectionView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 10.03.2022.
//

import UIKit

final class OCreatingPlanSectionView: UIView {
    lazy var checkedView = makeCheckedView()
    lazy var titleLabel = makeTitleLabel()
    lazy var percentLabel = makePercentLabel()
    
    private var timer: Timer?
    
    private let title: String
    private let rows: [String]
    
    private lazy var rowsViews = [OCreatingPlanRowView]()
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    init(title: String, rows: [String]) {
        self.title = title
        self.rows = rows
        
        super.init(frame: .zero)
        
        makeConstraints()
        addRows()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OCreatingPlanSectionView {
    func hide() {
        checkedView.alpha = 0
        titleLabel.alpha = 0
        percentLabel.alpha = 0
        rowsViews.forEach {
            $0.alpha = 0
        }
        timer?.invalidate()
        timer = nil
    }
    
    func openUp(completion: @escaping () -> Void) {
        titleLabel.alpha = 1
        percentLabel.alpha = 1
        
        calculatePercent()
        openUsRows { [weak self] in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.checkedView.alpha = 1
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    completion()
                }
            }
        }
    }
}

// MARK: Private
private extension OCreatingPlanSectionView {
    func addRows() {
        rows.enumerated().forEach { index, title in
            let rowView = OCreatingPlanRowView(title: title)
            rowView.backgroundColor = UIColor.clear
            rowView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(rowView)
            
            let leading = rowView.leadingAnchor.constraint(equalTo: leadingAnchor)
            let trailing = rowView.trailingAnchor.constraint(equalTo: trailingAnchor)
            [leading, trailing].forEach { $0.isActive = true }
            
            if index == 0 {
                let top = rowView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18.scale)
                top.isActive = true
            } else if let previousView = rowsViews.last {
                let top = rowView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 17.scale)
                top.isActive = true
            }
            
            if index == (rows.count - 1) {
                let bottom = rowView.bottomAnchor.constraint(equalTo: bottomAnchor)
                bottom.isActive = true
            }
            
            rowsViews.append(rowView)
        }
        
        layoutSubviews()
    }
    
    func calculatePercent() {
        let attrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .lineHeight(20.4.scale)
            .letterSpacing(-0.44.scale)
        
        let duration = Double(rowsViews.count * 1)
        var seconds = Double(0)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            seconds += 0.1
            
            var percent = Int(seconds / duration * 100)
            if percent > 100 {
                percent = 100
            }
            self?.percentLabel.attributedText = String(format: "%i%%", percent).attributed(with: attrs)
            
            if seconds >= duration {
                timer.invalidate()
            }
        }
    }
    
    func openUsRows(index: Int = 0, completion: @escaping () -> Void) {
        guard rowsViews.indices.contains(index) else {
            completion()
            return
        }
        
        UIView.animate(withDuration: 1, animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.rowsViews[index].alpha = 1
        }, completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.openUsRows(index: index + 1, completion: completion)
        })
    }
}

// MARK: Make constraints
private extension OCreatingPlanSectionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            checkedView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 52.scale),
            titleLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -8.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            percentLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OCreatingPlanSectionView {
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "OPlanView.CheckSection")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .lineHeight(20.4.scale)
            .letterSpacing(-0.44.scale)
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = title.attributed(with: attrs)
        view.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePercentLabel() -> UILabel {
        let view = UILabel()
        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
