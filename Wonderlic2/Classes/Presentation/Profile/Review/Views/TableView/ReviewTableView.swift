//
//  ReviewTableView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 06.06.2022.
//

import UIKit

protocol ReviewTableViewDelegate: AnyObject {
    func reviewTableDidReachedBottom()
    func reviewTableDidTapped(element: Review)
}

final class ReviewTableView: UITableView {
    weak var mainDelegate: ReviewTableViewDelegate?
    
    private lazy var elements = [ReviewTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ReviewTableView {
    func setup(elements: [ReviewTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ReviewTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .question(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ReviewTableQuestionCell.self)) as! ReviewTableQuestionCell
            cell.setup(element: element)
            return cell
        case .separator:
            return dequeueReusableCell(withIdentifier: String(describing: ReviewTableSeparatorCell.self))!
        }
    }
}

// MARK: UITableViewDelegate
extension ReviewTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .question:
            return UITableView.automaticDimension
        case .separator:
            return 1.scale
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (elements.count - 1) == indexPath.row {
            mainDelegate?.reviewTableDidReachedBottom()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .question(element) = elements[indexPath.row] else {
            return
        }
        
        mainDelegate?.reviewTableDidTapped(element: element)
    }
}

// MARK: Private
private extension ReviewTableView {
    func initialize() {
        register(ReviewTableQuestionCell.self, forCellReuseIdentifier: String(describing: ReviewTableQuestionCell.self))
        register(ReviewTableSeparatorCell.self, forCellReuseIdentifier: String(describing: ReviewTableSeparatorCell.self))
        
        dataSource = self
        delegate = self
    }
}
