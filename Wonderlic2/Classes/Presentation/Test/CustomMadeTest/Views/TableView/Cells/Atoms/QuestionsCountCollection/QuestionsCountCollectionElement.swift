//
//  QuestionsCountCollectionElement.swift
//  ITExams
//
//  Created by Андрей Чернышев on 15.06.2022.
//

final class QuestionsCountCollectionElement {
    let count: Int
    var isSelected: Bool
    
    init(count: Int,
         isSelected: Bool) {
        self.count = count
        self.isSelected = isSelected
    }
}
