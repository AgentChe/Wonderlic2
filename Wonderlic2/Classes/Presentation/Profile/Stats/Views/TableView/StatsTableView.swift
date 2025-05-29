//
//  StatsTableView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 03.06.2022.
//

import UIKit

protocol StatsTableViewDelegate: AnyObject {
    func statsTableDidTappedUnlock()
}

final class StatsTableView: UITableView {
    weak var mainDelegate: StatsTableViewDelegate?
    
    private(set) lazy var elements = [StatsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension StatsTableView {
    func setup(elements: [StatsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension StatsTableView: UITableViewDataSource {
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
        case .main(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: StatsTableMainCell.self)) as! StatsTableMainCell
            cell.setup(element: element)
            return cell
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: StatsTableTitleCell.self)) as! StatsTableTitleCell
            cell.setup(element: element)
            return cell
        case .unlockPremiumButton(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: StatsTableUnlockPremiumButtonCell.self)) as! StatsTableUnlockPremiumButtonCell
            cell.setup(element: element)
            return cell
        case .dailyMetrics(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: StatsTableDailyMetricsCell.self)) as! StatsTableDailyMetricsCell
            cell.setup(element: element)
            return cell
        case .passRate(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: StatsTablePassRateCell.self)) as! StatsTablePassRateCell
            cell.setup(element: element)
            return cell
        case .subject(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: StatsTableSubjectCell.self)) as! StatsTableSubjectCell
            cell.setup(element: element)
            return cell
        case .unlockPremiumFake:
            return dequeueReusableCell(withIdentifier: String(describing: StatsTableUnlockPremiumFakeCell.self))!
        }
    }
}

// MARK: UITableViewDelegate
extension StatsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .title:
            return UITableView.automaticDimension
        case .main:
            return 172.scale
        case .unlockPremiumButton:
            return 52.scale
        case .dailyMetrics:
            return 192.scale
        case .passRate:
            return 271.scale
        case .subject:
            return 152.scale
        case .unlockPremiumFake:
            return 1087.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .unlockPremiumButton, .unlockPremiumFake:
            mainDelegate?.statsTableDidTappedUnlock()
        default:
            return
        }
    }
}

// MARK: Private
private extension StatsTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(StatsTableMainCell.self, forCellReuseIdentifier: String(describing: StatsTableMainCell.self))
        register(StatsTableTitleCell.self, forCellReuseIdentifier: String(describing: StatsTableTitleCell.self))
        register(StatsTableUnlockPremiumButtonCell.self, forCellReuseIdentifier: String(describing: StatsTableUnlockPremiumButtonCell.self))
        register(StatsTableDailyMetricsCell.self, forCellReuseIdentifier: String(describing: StatsTableDailyMetricsCell.self))
        register(StatsTablePassRateCell.self, forCellReuseIdentifier: String(describing: StatsTablePassRateCell.self))
        register(StatsTableSubjectCell.self, forCellReuseIdentifier: String(describing: StatsTableSubjectCell.self))
        register(StatsTableUnlockPremiumFakeCell.self, forCellReuseIdentifier: String(describing: StatsTableUnlockPremiumFakeCell.self))
        
        dataSource = self
        delegate = self
    }
}
