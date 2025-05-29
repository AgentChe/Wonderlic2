//
//  CustomMadeTestTableSubjectsCell.swift
//  ITExams
//
//  Created by Андрей Чернышев on 14.06.2022.
//

import UIKit

final class CustomMadeTestTableSubjectsCell: UITableViewCell {
    lazy var subjectsView = makeSubjectsView()
    
    weak var tableView: UITableView?
    
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
extension CustomMadeTestTableSubjectsCell {
    func setup(element: [CustomMadeTestSubjectElement]) {
        subjectsView.setup(elements: element) {
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
        }
    }
}

// MARK: Private
private extension CustomMadeTestTableSubjectsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension CustomMadeTestTableSubjectsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            subjectsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subjectsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subjectsView.topAnchor.constraint(equalTo: contentView.topAnchor),
            subjectsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CustomMadeTestTableSubjectsCell {
    func makeSubjectsView() -> SubjectsView {
        let view = SubjectsView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
