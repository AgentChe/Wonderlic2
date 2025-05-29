//
//  MyProfileTableView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 13.05.2022.
//

import UIKit

protocol MyProfileTableViewDelegate: AnyObject {
    func myProfileDidSelect(element: MyProfileTableElement)
}

final class MyProfileTableView: UITableView {
    weak var mainDelegate: MyProfileTableViewDelegate?
    
    private lazy var elements = [MyProfileTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MyProfileTableView {
    func setup(elements: [MyProfileTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension MyProfileTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .dateOfExam(let value):
            let cell = dequeueReusableCell(withIdentifier: String(describing: MyProfilePropertyCell.self)) as! MyProfilePropertyCell
            cell.setup(title: "MyProfile.DateOfExam".localized, value: value)
            return cell
        case .course(let value):
            let cell = dequeueReusableCell(withIdentifier: String(describing: MyProfilePropertyCell.self)) as! MyProfilePropertyCell
            cell.setup(title: "MyProfile.Course".localized, value: value)
            return cell
        case .studyMode(let value):
            let cell = dequeueReusableCell(withIdentifier: String(describing: MyProfilePropertyCell.self)) as! MyProfilePropertyCell
            cell.setup(title: "MyProfile.StudyMode".localized, value: value)
            return cell
        case .dailyGoal(let value):
            let cell = dequeueReusableCell(withIdentifier: String(describing: MyProfilePropertyCell.self)) as! MyProfilePropertyCell
            cell.setup(title: "MyProfile.DailyGoal".localized, value: value)
            return cell
        case .resetProgress(let activity):
            let cell = dequeueReusableCell(withIdentifier: String(describing: MyProfileResetProgressCell.self)) as! MyProfileResetProgressCell
            cell.setup(activity: activity)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension MyProfileTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64.scale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        mainDelegate?.myProfileDidSelect(element: element)
    }
}

// MARK: Private
private extension MyProfileTableView {
    func initialize() {
        register(MyProfilePropertyCell.self, forCellReuseIdentifier: String(describing: MyProfilePropertyCell.self))
        register(MyProfileResetProgressCell.self, forCellReuseIdentifier: String(describing: MyProfileResetProgressCell.self))
        
        dataSource = self
        delegate = self
    }
}
