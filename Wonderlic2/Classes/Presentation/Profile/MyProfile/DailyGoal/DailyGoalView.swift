//
//  DailyGoalView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 16.05.2022.
//

import UIKit

final class DailyGoalView: UIView {
    lazy var headerLabel = makeHeaderLabel()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var suDayView = makeDailyView(day: .su)
    lazy var mnDayView = makeDailyView(day: .mn)
    lazy var tuDayView = makeDailyView(day: .tu)
    lazy var weDayView = makeDailyView(day: .we)
    lazy var thDayView = makeDailyView(day: .th)
    lazy var frDayView = makeDailyView(day: .fr)
    lazy var saDayView = makeDailyView(day: .sa)
    lazy var pickerView = makePickerView()
    lazy var minLabel = makeMinLabel()
    lazy var button = makeButton()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension DailyGoalView {
    func setup(minutes: Int) {
        let index = minutes - 1
        
        guard index >= 0 && index <= pickerView(pickerView, numberOfRowsInComponent: 0) else {
            return
        }
        
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    func setup(daysOfWeek: [DayOfWeek]) {
        let views = [
            suDayView,
            mnDayView,
            tuDayView,
            weDayView,
            thDayView,
            frDayView,
            saDayView
        ]
        
        views.forEach { view in
            view.isChecked = daysOfWeek.contains(where: { dayOfWeek -> Bool in
                dayOfWeek == view.day
            })
        }
    }
}

// MARK: UIPickerViewDataSource
extension DailyGoalView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        51
    }
}

// MARK: UIPickerViewDelegate
extension DailyGoalView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        
        if label == nil {
            label = UILabel()
            label?.backgroundColor = UIColor.clear
        }
        
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 32.scale))
        
        let string = String(row + 10)
        
        label?.attributedText = string.attributed(with: attrs)
        
        label?.sizeToFit()
        
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        38.scale
    }
}

// MARK: Private
private extension DailyGoalView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
    
    @objc
    func tapped(sender: UIButton) {
        guard let dailyButton = sender as? ODailyView else {
            return
        }
        
        dailyButton.isChecked.toggle()
    }
}

// MARK: Make constraints
private extension DailyGoalView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 34.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            suDayView.widthAnchor.constraint(equalToConstant: 50.scale),
            suDayView.heightAnchor.constraint(equalToConstant: 50.scale),
            suDayView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 46.scale),
            suDayView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            mnDayView.widthAnchor.constraint(equalToConstant: 50.scale),
            mnDayView.heightAnchor.constraint(equalToConstant: 50.scale),
            mnDayView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 104.scale),
            mnDayView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            tuDayView.widthAnchor.constraint(equalToConstant: 50.scale),
            tuDayView.heightAnchor.constraint(equalToConstant: 50.scale),
            tuDayView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 162.scale),
            tuDayView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            weDayView.widthAnchor.constraint(equalToConstant: 50.scale),
            weDayView.heightAnchor.constraint(equalToConstant: 50.scale),
            weDayView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 220.scale),
            weDayView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            thDayView.widthAnchor.constraint(equalToConstant: 50.scale),
            thDayView.heightAnchor.constraint(equalToConstant: 50.scale),
            thDayView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 278.scale),
            thDayView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            frDayView.widthAnchor.constraint(equalToConstant: 50.scale),
            frDayView.heightAnchor.constraint(equalToConstant: 50.scale),
            frDayView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 134.scale),
            frDayView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 82.scale)
        ])
        
        NSLayoutConstraint.activate([
            saDayView.widthAnchor.constraint(equalToConstant: 50.scale),
            saDayView.heightAnchor.constraint(equalToConstant: 50.scale),
            saDayView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 192.scale),
            saDayView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 82.scale)
        ])
    
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: saDayView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 40.scale : 20.scale),
            pickerView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: ScreenSize.isIphoneXFamily ? -40.scale : -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            minLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 214.scale),
            minLabel.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            button.heightAnchor.constraint(equalToConstant: 48.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension DailyGoalView {
    func makeHeaderLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.Inter.bold(size: 17.scale))
            .lineHeight(20.4.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.DailyGoal.Header".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 28.scale))
            .lineHeight(33.6.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.DailyGoal.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono300)
            .font(Fonts.Inter.regular(size: 15.scale))
            .lineHeight(22.5.scale)
            .letterSpacing(-0.14.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.DailyGoal.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDailyView(day: DayOfWeek) -> ODailyView {
        let view = ODailyView()
        view.day = day
        view.isChecked = false
        view.layer.cornerRadius = 25.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makePickerView() -> UIPickerView {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMinLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 20.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.44.scale)
        
        let view = UILabel()
        view.attributedText = "Onboarding.DailyGoal.min".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .letterSpacing(-0.44.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 36.scale, height: 36.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
