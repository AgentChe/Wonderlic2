//
//  StatsTableDailyMetricsCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 03.06.2022.
//

import UIKit

final class StatsTableDailyMetricsCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var currentStreakPlaceholderLabel = makePlaceholderLabel(text: "Stats.DailyMetrics.CurrentStreak".localized)
    lazy var currentStreakValueLabel = makeLabel()
    lazy var longestStreakPlaceholderLabel = makePlaceholderLabel(text: "Stats.DailyMetrics.LongestStreak".localized)
    lazy var longestStreakValueLabel = makeLabel()
    lazy var weekView = makeWeekView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension StatsTableDailyMetricsCell {
    func setup(element: StatsTableDailyMetrics) {
        setup(streaks: element.currentStreak, longest: element.longestStreak)
        setup(week: element.week)
    }
    
    func setup(streaks current: Int, longest: Int) {
        let daysAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 40.scale))
            .lineHeight(40.scale)
            .letterSpacing(-0.44.scale)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 15.scale))
            .lineHeight(21.scale)
            .letterSpacing(-0.44.scale)
        
        let placeholder = "Stats.DailyMetrics.Days".localized.attributed(with: placeholderAttrs)
        
        let currentStreakDays = String(current).attributed(with: daysAttrs)
        let longestStreakDays = String(longest).attributed(with: daysAttrs)
        
        let currentStreak = NSMutableAttributedString()
        currentStreak.append(currentStreakDays)
        currentStreak.append(placeholder)
        currentStreakValueLabel.attributedText = currentStreak
        
        let longestStreak = NSMutableAttributedString()
        longestStreak.append(longestStreakDays)
        longestStreak.append(placeholder)
        longestStreakValueLabel.attributedText = longestStreak
    }
    
    func setup(week: [StatsTableDailyMetrics.WeekDay]) {
        weekView.arrangedSubviews.forEach {
            weekView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        week.forEach { weekDay in
            let dayView = StatsDayMetricView()
            dayView.backgroundColor = UIColor.clear
            dayView.translatesAutoresizingMaskIntoConstraints = false
            dayView.setup(element: weekDay)
            
            weekView.addArrangedSubview(dayView)
        }
    }
}

// MARK: Private
private extension StatsTableDailyMetricsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension StatsTableDailyMetricsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            currentStreakPlaceholderLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            currentStreakPlaceholderLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            currentStreakValueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            currentStreakValueLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 47.scale)
        ])
        
        NSLayoutConstraint.activate([
            longestStreakPlaceholderLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 172.scale),
            longestStreakPlaceholderLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            longestStreakValueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 172.scale),
            longestStreakValueLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 47.scale)
        ])
        
        NSLayoutConstraint.activate([
            weekView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            weekView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            weekView.heightAnchor.constraint(equalToConstant: 71.scale),
            weekView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension StatsTableDailyMetricsCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePlaceholderLabel(text: String) -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono300)
            .font(Fonts.Inter.regular(size: 15.scale))
            .lineHeight(23.scale)
            .letterSpacing(-0.14.scale)
        
        let view = UILabel()
        view.attributedText = text.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeWeekView() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 13.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
