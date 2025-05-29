//
//  SettingsTableView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 13.05.2022.
//

import UIKit

protocol SettingsTableViewDelegate: AnyObject {
    func settingsTableDidSelect(element: SettingsTableElement)
}

final class SettingsTableView: UITableView {
    weak var mainDelegate: SettingsTableViewDelegate?
    
    private lazy var elements = [SettingsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SettingsTableView {
    func setup(elements: [SettingsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension SettingsTableView: UITableViewDataSource {
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
        case .premium:
            return dequeueReusableCell(withIdentifier: String(describing: SettingsPremiumCell.self))!
        case .profile:
            return dequeueReusableCell(withIdentifier: String(describing: SettingsProfileCell.self))!
        case .title(let title):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsTitleCell.self)) as! SettingsTitleCell
            cell.setup(title: title)
            return cell
        case .app:
            return dequeueReusableCell(withIdentifier: String(describing: SettingsAppCell.self))!
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .premium:
            return 120.scale
        case .profile:
            return 80.scale
        case .title:
            return 20.scale
        case .app:
            return 256.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        mainDelegate?.settingsTableDidSelect(element: element)
    }
}

// MARK: Private
private extension SettingsTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(SettingsPremiumCell.self, forCellReuseIdentifier: String(describing: SettingsPremiumCell.self))
        register(SettingsProfileCell.self, forCellReuseIdentifier: String(describing: SettingsProfileCell.self))
        register(SettingsTitleCell.self, forCellReuseIdentifier: String(describing: SettingsTitleCell.self))
        register(SettingsAppCell.self, forCellReuseIdentifier: String(describing: SettingsAppCell.self))
        
        dataSource = self
        delegate = self
    }
}
