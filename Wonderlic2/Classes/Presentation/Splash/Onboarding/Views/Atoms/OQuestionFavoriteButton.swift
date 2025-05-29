//
//  OQuestionFavoriteButton.swift
//  ITExams
//
//  Created by Андрей Чернышев on 07.06.2022.
//

import UIKit

final class OQuestionFavoriteButton: TapAreaButton {
    var question: Question! {
        didSet {
            isFavorite = question.isSaved
        }
    }
    
    lazy var isFavorite = question.isSaved {
        didSet {
            update()
        }
    }
}

// MARK: Private
private extension OQuestionFavoriteButton {
    func update() {
        let image = UIImage(named: isFavorite ? "OTest.Favorite" : "OTest.NotFavorite")
        setImage(image, for: .normal)
    }
}
