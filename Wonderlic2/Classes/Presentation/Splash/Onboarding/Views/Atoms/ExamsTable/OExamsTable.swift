//
//  OExamsTable.swift
//  ITExams
//
//  Created by Андрей Чернышев on 04.03.2022.
//

import UIKit

protocol OExamsTableDelegate: AnyObject {
    func examsTableDidChangeSelected()
}

final class OExamsTable: UITableView {
    weak var mainDelegate: OExamsTableDelegate?
    
    lazy var elements = [OExamsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OExamsTable {
    func setup(elements: [OExamsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension OExamsTable: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: OExamsTableCell.self)) as! OExamsTableCell
        cell.setup(element: elements[indexPath.section])
        return cell
    }
}

// MARK: UITableViewDelegate
extension OExamsTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !elements[indexPath.section].isSelected else {
            return
        }
        
        if let selectedIndex = elements.firstIndex(where: { $0.isSelected }) {
            elements[selectedIndex].isSelected = false
        }
        
        elements[indexPath.section].isSelected = true
        
        reloadData()
        
        mainDelegate?.examsTableDidChangeSelected()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        16.scale
    }
}

// MARK: Private
private extension OExamsTable {
    func initialize() {
        register(OExamsTableCell.self, forCellReuseIdentifier: String(describing: OExamsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
