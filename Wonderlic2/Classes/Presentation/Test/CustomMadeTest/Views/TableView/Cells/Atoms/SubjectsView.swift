//
//  SubjectsView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 14.06.2022.
//

import UIKit
import RxSwift

final class SubjectsView: UIView {
    enum State {
        case none, compressed, all
    }
    
    private lazy var elements = [CustomMadeTestSubjectElement]()
    
    private var state = State.none
    
    private lazy var totalHeight = CGFloat(0)
    
    private lazy var disposeBag = DisposeBag()
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 375.scale, height: totalHeight)
    }
}

// MARK: Public
extension SubjectsView {
    func setup(elements: [CustomMadeTestSubjectElement], resize: @escaping () -> Void) {
        guard state == .none else {
            return
        }
        
        self.elements = elements
        
        state = elements.count > 3 ? .compressed : .all
        
        fill(resize: resize)
    }
}

// MARK: Private
private extension SubjectsView {
    func clear() {
        disposeBag = DisposeBag()
        
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    func fill(resize: @escaping () -> Void) {
        let maxLineWidth = 375.scale
        let maxButtonWidth = 330.scale
        
        let buttonHeight = 31.scale
        let padding = 12.scale
        
        var x = CGFloat(20.scale)
        var y = CGFloat(0)
        
        let more = CustomMadeTestSubjectElement(subject: Subject(id: -1000,
                                                                 name: "CustomMadeTest.More".localized),
                                                isSelected: false)
        let compressedElements = Array(elements.prefix(3)) + [more]
        let workingElements = state == .compressed ? compressedElements : elements
        
        workingElements.forEach { element in
            let width = min(maxButtonWidth, SubjectButton.width(for: element))
            
            let stretched = (padding + width)
            
            let willFit = (maxLineWidth - x) >= stretched
            
            if !willFit {
                x = 20.scale
                y += (buttonHeight + padding)
            }
            
            let button = SubjectButton(element: element)
            button.layer.cornerRadius = 12.scale
            button.frame.size = CGSize(width: width, height: buttonHeight)
            button.frame.origin = CGPoint(x: x, y: y)
            addSubview(button)
            
            button.rx.tap
                .map { element }
                .filter { $0.subject.id != -1000 }
                .bind(to: Binder(button) { base, element in
                    element.isSelected.toggle()
                    base.update()
                })
                .disposed(by: disposeBag)
            
            button.rx.tap
                .map { element }
                .filter { $0.subject.id == -1000 }
                .bind(to: Binder(self) { base, element in
                    base.state = .all
                    base.clear()
                    base.fill(resize: resize)
                })
                .disposed(by: disposeBag)
            
            x += stretched
        }
        
        totalHeight = y + buttonHeight
        
        invalidateIntrinsicContentSize()
        
        resize()
    }
}
