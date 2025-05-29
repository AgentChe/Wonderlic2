//
//  TestStatsTableView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import UIKit

protocol TestStatsTableViewDelegate: AnyObject {
    func testStatsTableDidTappedRestart()
    func testStatsTableDidTappedNextTest()
    func testStatsTableDidTapped(filter: TestStatsFilter)
    func testStatsTableDidTapped(question: TestStatsTableAnswer)
}

final class TestStatsTableView: UITableView {
    weak var mainDelegate: TestStatsTableViewDelegate?
    
    private lazy var elements = [TestStatsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TestStatsTableView {
    func setup(elements: [TestStatsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension TestStatsTableView: UITableViewDataSource {
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
        case .progress(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TestStatsTableProgressCell.self)) as! TestStatsTableProgressCell
            cell.setup(element: element)
            return cell
        case .info(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TestStatsTableInfoCell.self)) as! TestStatsTableInfoCell
            cell.setup(element: element)
            return cell
        case .actions:
            let cell = dequeueReusableCell(withIdentifier: String(describing: TestStatsTableActionsCell.self)) as! TestStatsTableActionsCell
            cell.mainDelegate = mainDelegate
            return cell
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TestStatsTableTitleCell.self)) as! TestStatsTableTitleCell
            cell.setup(element: element)
            return cell
        case .filters:
            let cell = dequeueReusableCell(withIdentifier: String(describing: TestStatsTableFilterCell.self)) as! TestStatsTableFilterCell
            cell.mainDelegate = mainDelegate
            return cell
        case .answer(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TestStatsTableAnswerCell.self)) as! TestStatsTableAnswerCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension TestStatsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .progress:
            return 184.scale
        case .actions:
            return 48.scale
        case .filters:
            return 31.scale
        case .info, .title, .answer:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .answer(element) = elements[indexPath.row] else {
            return
        }
        
        mainDelegate?.testStatsTableDidTapped(question: element)
    }
}

// MARK: Private
private extension TestStatsTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(TestStatsTableProgressCell.self, forCellReuseIdentifier: String(describing: TestStatsTableProgressCell.self))
        register(TestStatsTableInfoCell.self, forCellReuseIdentifier: String(describing: TestStatsTableInfoCell.self))
        register(TestStatsTableActionsCell.self, forCellReuseIdentifier: String(describing: TestStatsTableActionsCell.self))
        register(TestStatsTableTitleCell.self, forCellReuseIdentifier: String(describing: TestStatsTableTitleCell.self))
        register(TestStatsTableFilterCell.self, forCellReuseIdentifier: String(describing: TestStatsTableFilterCell.self))
        register(TestStatsTableAnswerCell.self, forCellReuseIdentifier: String(describing: TestStatsTableAnswerCell.self))
        
        dataSource = self
        delegate = self
    }
}
