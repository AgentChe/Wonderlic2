//
//  CoursesTableView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 26.04.2022.
//

import UIKit

final class CoursesTableView: UITableView {
    private(set) lazy var elements = [CoursesTableCourseElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CoursesTableView {
    func setup(elements: [CoursesTableCourseElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension CoursesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: CoursesTableCourseCell.self)) as! CoursesTableCourseCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension CoursesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        elements.enumerated().forEach { index, element in
            element.isSelected = indexPath.row == index
        }
        
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension CoursesTableView {
    func initialize() {
        register(CoursesTableCourseCell.self, forCellReuseIdentifier: String(describing: CoursesTableCourseCell.self))
        
        dataSource = self
        delegate = self
    }
}
