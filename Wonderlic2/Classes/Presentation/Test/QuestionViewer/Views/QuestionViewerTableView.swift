//
//  QuestionViewerTableView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 15.06.2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol QuestionViewerTableDelegate: AnyObject {
    func questionViewerTableDidExpand(contentType: QuestionContentCollectionType)
}

final class QuestionViewerTableView: UITableView {
    weak var mainDelegate: QuestionViewerTableDelegate?
    
    private lazy var elements = [TestingCellType]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension QuestionViewerTableView {
    func setup(elements: [TestingCellType]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension QuestionViewerTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .content(content):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableContentCell.self), for: indexPath) as! QuestionTableContentCell
            cell.configure(content: content) { [weak self] in
                self?.mainDelegate?.questionViewerTableDidExpand(contentType: $0)
            }
            return cell
        case let .question(question, html):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableQuestionCell.self), for: indexPath) as! QuestionTableQuestionCell
            cell.configure(question: question, questionHtml: html)
            return cell
        case .answers:
            return UITableViewCell()
        case .explanationTitle:
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableExplanationTitleCell.self), for: indexPath) as! QuestionTableExplanationTitleCell
            return cell
        case let .explanationImage(url):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableExplanationImageCell.self), for: indexPath) as! QuestionTableExplanationImageCell
            cell.confugure(image: url)
            return cell
        case let .explanationText(explanation, html):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableExplanationTextCell.self), for: indexPath) as! QuestionTableExplanationTextCell
            cell.confugure(explanation: explanation, html: html)
            return cell
        case let .result(elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableAnswersCell.self), for: indexPath) as! QuestionTableAnswersCell
            cell.configure(result: elements)
            return cell
        case let .reference(reference):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableQuestionReferenceCell.self), for: indexPath) as! QuestionTableQuestionReferenceCell
            cell.confugure(reference: reference)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension QuestionViewerTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .explanationImage(url) = elements[indexPath.row] else {
            return
        }
        
        mainDelegate?.questionViewerTableDidExpand(contentType: .image(url))
    }
}

// MARK: Private
private extension QuestionViewerTableView {
    func initialize() {
        register(QuestionTableContentCell.self, forCellReuseIdentifier: String(describing: QuestionTableContentCell.self))
        register(QuestionTableQuestionCell.self, forCellReuseIdentifier: String(describing: QuestionTableQuestionCell.self))
        register(QuestionTableAnswersCell.self, forCellReuseIdentifier: String(describing: QuestionTableAnswersCell.self))
        register(QuestionTableExplanationImageCell.self, forCellReuseIdentifier: String(describing: QuestionTableExplanationImageCell.self))
        register(QuestionTableExplanationTextCell.self, forCellReuseIdentifier: String(describing: QuestionTableExplanationTextCell.self))
        register(QuestionTableExplanationTitleCell.self, forCellReuseIdentifier: String(describing: QuestionTableExplanationTitleCell.self))
        register(QuestionTableQuestionReferenceCell.self, forCellReuseIdentifier: String(describing: QuestionTableQuestionReferenceCell.self))
        
        dataSource = self
        delegate = self
    }
}
