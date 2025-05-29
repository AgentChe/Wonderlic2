//
//  TestEmptyViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 14.06.2022.
//

import UIKit
import RxSwift

protocol TestEmptyViewControllerDelegate: AnyObject {
    func testEmptyDidTappedTakeTest()
}

final class TestEmptyViewController: UIViewController {
    enum Mode {
        case noSaved, noMissed
    }
    
    weak var delegate: TestEmptyViewControllerDelegate?
    
    private lazy var noSavedView = NoSavedQuestionsView()
    private lazy var noMissedView = NoMissedQuestionsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let mode: Mode
    
    private init(mode: Mode) {
        self.mode = mode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        switch mode {
        case .noSaved:
            view = noSavedView
        case .noMissed:
            view = noMissedView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable
            .merge(
                noSavedView.closeButton.rx.tap.asObservable(),
                noMissedView.closeButton.rx.tap.asObservable()
            )
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        noMissedView.takeTestButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true) {
                    base.delegate?.testEmptyDidTappedTakeTest()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TestEmptyViewController {
    static func make(mode: Mode) -> TestEmptyViewController {
        let vc = TestEmptyViewController(mode: mode)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
