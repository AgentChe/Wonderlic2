//
//  CustomMadeTestTableView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 14.06.2022.
//

import UIKit

protocol CustomMadeTestTableViewDelegate: AnyObject {
    func customMadeTestTableDidTappedStartTest(attributes: CustomTestAttributes)
}

final class CustomMadeTestTableView: UITableView {
    weak var mainDelegate: CustomMadeTestTableViewDelegate?
    
    private lazy var elements = [CustomMadeTestTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CustomMadeTestTableView {
    func setup(elements: [CustomMadeTestTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension CustomMadeTestTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .offset:
            let cell = dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        case .startTest(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CustomMadeTestTableStartCell.self)) as! CustomMadeTestTableStartCell
            cell.mainDelegate = mainDelegate
            cell.setup(element: element)
            return cell
        case .title(let title):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CustomMadeTestTableTitleCell.self)) as! CustomMadeTestTableTitleCell
            cell.setup(title: title)
            return cell
        case .subjects(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CustomMadeTestTableSubjectsCell.self)) as! CustomMadeTestTableSubjectsCell
            cell.tableView = self
            cell.setup(element: element)
            return cell
        case .missedQuestions(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CustomMadeTestTableSwitchCell.self)) as! CustomMadeTestTableSwitchCell
            cell.setup(element: element)
            return cell
        case .answeredQuestions(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CustomMadeTestTableSwitchCell.self)) as! CustomMadeTestTableSwitchCell
            cell.setup(element: element)
            return cell
        case .questionsCount(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CustomMadeTestTableCountCell.self)) as! CustomMadeTestTableCountCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension CustomMadeTestTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .startTest:
            return 48.scale
        case .missedQuestions, .answeredQuestions:
            return 54.scale
        case .questionsCount:
            return 54.scale
        case .title, .subjects:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension CustomMadeTestTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(CustomMadeTestTableStartCell.self, forCellReuseIdentifier: String(describing: CustomMadeTestTableStartCell.self))
        register(CustomMadeTestTableTitleCell.self, forCellReuseIdentifier: String(describing: CustomMadeTestTableTitleCell.self))
        register(CustomMadeTestTableSubjectsCell.self, forCellReuseIdentifier: String(describing: CustomMadeTestTableSubjectsCell.self))
        register(CustomMadeTestTableSwitchCell.self, forCellReuseIdentifier: String(describing: CustomMadeTestTableSwitchCell.self))
        register(CustomMadeTestTableCountCell.self, forCellReuseIdentifier: String(describing: CustomMadeTestTableCountCell.self))
        
        dataSource = self
        delegate = self
    }
}
