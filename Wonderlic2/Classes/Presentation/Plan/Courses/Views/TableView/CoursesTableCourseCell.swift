//
//  CoursesTableCourseCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 26.04.2022.
//

import UIKit

final class CoursesTableCourseCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var nameLabel = makeLabel()
    lazy var subTitleLabel = makeLabel()
    lazy var currentView = makeCurrentView()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Inter.semiBold(size: 17.scale))
        .lineHeight(20.4.scale)
        .letterSpacing(-0.44.scale)
    private lazy var textAttrs = TextAttributes()
        .textColor(Appearance.mono300)
        .font(Fonts.Inter.regular(size: 15.scale))
        .lineHeight(20.4.scale)
        .letterSpacing(-0.14.scale)
    
    private lazy var nameLabelTrailingConstraint = NSLayoutConstraint()
    
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
extension CoursesTableCourseCell {
    func setup(element: CoursesTableCourseElement) {
        nameLabel.attributedText = element.course.name.attributed(with: nameAttrs)
        subTitleLabel.attributedText = element.course.subTitle.attributed(with: textAttrs)
        
        container.layer.borderWidth = element.isSelected ? 2.scale : 0
        container.layer.borderColor = element.isSelected ? Appearance.main300.cgColor : UIColor.clear.cgColor
        
        container.backgroundColor = element.isSelected ? Appearance.main300.withAlphaComponent(0.1) : Appearance.mono100
        
        currentView.isHidden = !element.isCurrent
        
        nameLabelTrailingConstraint.constant = element.isCurrent ? -80.scale : -16.scale
    }
}

// MARK: Private
private extension CoursesTableCourseCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension CoursesTableCourseCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        nameLabelTrailingConstraint = nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            nameLabelTrailingConstraint,
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12.scale),
            subTitleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            currentView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            currentView.topAnchor.constraint(equalTo: container.topAnchor, constant: 21.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CoursesTableCourseCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCurrentView() -> CourseCurrentView {
        let view = CourseCurrentView()
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 9.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
