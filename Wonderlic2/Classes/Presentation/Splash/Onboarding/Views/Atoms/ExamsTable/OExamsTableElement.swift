//
//  OExamsTableElement.swift
//  ITExams
//
//  Created by Андрей Чернышев on 04.03.2022.
//

import Foundation

final class OExamsTableElement {
    let code: String
    let title: String
    let subTitle: String
    var isSelected: Bool
    
    init(code: String,
         title: String,
         subTitle: String,
         isSelected: Bool = false) {
        self.code = code
        self.title = title
        self.subTitle = subTitle
        self.isSelected = isSelected
    }
}
