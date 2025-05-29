//
//  StatsDayMetricView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 03.06.2022.
//

import UIKit

final class StatsDayMetricView: UIView {
    lazy var currentView = makeCurrentView()
    lazy var dayLabel = makeDayLabel()
    lazy var takenView = makeTakenView()
    lazy var plannedView = makePlannedView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 32.scale, height: 71.scale)
    }
}

// MARK: Public
extension StatsDayMetricView {
    func setup(element: StatsTableDailyMetrics.WeekDay) {
        let attrs = TextAttributes()
            .textColor(Appearance.mono300.withAlphaComponent(0.5))
            .font(Fonts.Inter.regular(size: 14.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.14.scale)
        dayLabel.attributedText = element.day.attributed(with: attrs)
        
        currentView.isHidden = !element.isCurrent
        
        takenView.image = UIImage(named: element.isTaken ? "Stats.Metric.Day.Selected" : "Stats.Metric.Day.Unselected")
        
        plannedView.isHidden = !element.isPlanned
    }
}

// MARK: Make constraints
private extension StatsDayMetricView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            currentView.widthAnchor.constraint(equalToConstant: 24.scale),
            currentView.heightAnchor.constraint(equalToConstant: 24.scale),
            currentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            currentView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: currentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            plannedView.widthAnchor.constraint(equalToConstant: 4.scale),
            plannedView.heightAnchor.constraint(equalToConstant: 4.scale),
            plannedView.centerXAnchor.constraint(equalTo: takenView.centerXAnchor),
            plannedView.bottomAnchor.constraint(equalTo: takenView.bottomAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            takenView.leadingAnchor.constraint(equalTo: leadingAnchor),
            takenView.trailingAnchor.constraint(equalTo: trailingAnchor),
            takenView.heightAnchor.constraint(equalToConstant: 32.scale),
            takenView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension StatsDayMetricView {
    func makeCurrentView() -> CircleView {
        let view = CircleView()
        view.backgroundColor = Appearance.main200
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDayLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTakenView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlannedView() -> CircleView {
        let view = CircleView()
        view.backgroundColor = Appearance.main300
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
