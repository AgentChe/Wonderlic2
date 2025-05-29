//
//  PracticeTableExamDateCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 09.06.2022.
//

import UIKit

final class PracticeTableExamDateCell: UITableViewCell {
    weak var mainDelegate: PracticeTableViewDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var changeExamDateButton = makeChangeExamDateButton()
    lazy var progressView = makeProgressView()
    lazy var upcomingLabel = makeUpcomingLabel()
    lazy var trackExamDateButton = makeTrackExamDateButton()
    lazy var daysLabel = makeLabel()
    
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
extension PracticeTableExamDateCell {
    func setup(element: PracticeTableExamDate) {
        let daysLeft = daysLeft(to: element.dateOfExam)

        daysLabel.attributedText = String(format: "Practice.ExamDate.DaysCount".localized, daysLeft)
            .attributed(with: TextAttributes()
                            .textColor(Appearance.mono200)
                            .font(Fonts.Inter.bold(size: 30.scale))
                            .lineHeight(36.scale)
                            .letterSpacing(-1.scale)
                            .textAlignment(.center))
        
        daysLabel.isHidden = daysLeft < 0
        trackExamDateButton.isHidden = daysLeft >= 0
        changeExamDateButton.isHidden = daysLeft < 0
        
        let percentPassed = percentPassed(referenceExamDate: element.referenceDateOfExam,
                                          examDate: element.dateOfExam)
        progressView.setup(progress: percentPassed)
    }
}

// MARK: Private
private extension PracticeTableExamDateCell {
    func initialize() {
        backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.white
        
        selectionStyle = .none
    }
    
    func daysLeft(to examDate: Date?) -> Int {
        guard let examDate = examDate else {
            return -1
        }
        
        let examDay = Calendar.current.startOfDay(for: examDate)
        let currentDay = Calendar.current.startOfDay(for: Date())
        
        let daysLeft = Calendar.current.dateComponents([.day], from: currentDay, to: examDay).day
        
        return daysLeft ?? -1
    }
    
    func percentPassed(referenceExamDate: Date?, examDate: Date?) -> Int? {
        guard let referenceExamDate = referenceExamDate, let examDate = examDate else {
            return nil
        }
        
        let referenceExamDay = Calendar.current.startOfDay(for: referenceExamDate)
        let currentDay = Calendar.current.startOfDay(for: Date())
        let examDay = Calendar.current.startOfDay(for: examDate)
        
        let daysLeft = Calendar.current.dateComponents([.day], from: currentDay, to: examDay).day ?? -1
        
        if daysLeft < 0 {
            return nil
        }
        
        let daysToPrepareForExam = Calendar.current.dateComponents([.day], from: referenceExamDay, to: examDay).day ?? 0
        let daysPassed = Calendar.current.dateComponents([.day], from: referenceExamDay, to: currentDay).day ?? 0
        
        if daysToPrepareForExam == 0 {
            return 100
        }
        
        if daysPassed == 0 {
            return 0
        }
        
        let percent = 100 / (Double(daysToPrepareForExam) / Double(daysPassed))
        return Int(percent)
    }
    
    @objc
    func tappedChangeDate() {
        mainDelegate?.practiceTableDidTappedChangeExamDate()
    }
    
    @objc
    func tappedTrackDate() {
        mainDelegate?.practiceTableDidTappedTrackExamDate()
    }
}

// MARK: Make constraints
private extension PracticeTableExamDateCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 57.scale)
        ])
        
        NSLayoutConstraint.activate([
            changeExamDateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.scale),
            changeExamDateButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            changeExamDateButton.widthAnchor.constraint(equalToConstant: 109.scale),
            changeExamDateButton.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40.scale)
        ])
        
        NSLayoutConstraint.activate([
            upcomingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            upcomingLabel.topAnchor.constraint(equalTo: progressView.topAnchor, constant: 80.scale)
        ])
        
        NSLayoutConstraint.activate([
            trackExamDateButton.widthAnchor.constraint(equalToConstant: 109.scale),
            trackExamDateButton.heightAnchor.constraint(equalToConstant: 39.scale),
            trackExamDateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            trackExamDateButton.topAnchor.constraint(equalTo: upcomingLabel.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            daysLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            daysLabel.topAnchor.constraint(equalTo: upcomingLabel.bottomAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PracticeTableExamDateCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .letterSpacing(-0.44.scale)
        
        let view = UILabel()
        view.attributedText = "Practice.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeChangeExamDateButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.regular(size: 14.scale))
            .letterSpacing(-0.14.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Practice.ChangeExamDate".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 8.scale
        view.addTarget(self, action: #selector(tappedChangeDate), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeProgressView() -> PracticeExamDateProgressView {
        let view = PracticeExamDateProgressView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeUpcomingLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono300)
            .font(Fonts.Inter.regular(size: 14.scale))
            .lineHeight(17.scale)
            .letterSpacing(-0.2.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Practice.ExamDate.UpcomingExam".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTrackExamDateButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.regular(size: 15.scale))
            .letterSpacing(-0.14.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Practice.ExamDate.TrackDate".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.mono300.withAlphaComponent(0.2).cgColor
        view.addTarget(self, action: #selector(tappedTrackDate), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
