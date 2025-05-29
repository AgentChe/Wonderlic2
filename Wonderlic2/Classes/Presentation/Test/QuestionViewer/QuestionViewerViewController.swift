//
//  QuestionViewerViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 15.06.2022.
//

import UIKit
import RxSwift
import AVFoundation
import AVKit

final class QuestionViewerViewController: UIViewController {
    lazy var mainView = QuestionViewerView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: QuestionViewerViewModel
    
    private init(question: Question, answeredIds: [Int]) {
        viewModel = QuestionViewerViewModel(question: question,
                                            answeredIds: answeredIds)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .empty()
            }
            
            return self.openError()
        }
        
        mainView.favoriteButton.rx.tap
            .withLatestFrom(viewModel.isSavedQuestion)
            .bind(to: viewModel.didTapMark)
            .disposed(by: disposeBag)
        
        viewModel.isSavedQuestion
            .drive(Binder(self) { base, isSaved in
                base.update(favorite: isSaved)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(self) { base, elements in
                base.mainView.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension QuestionViewerViewController {
    static func make(question: Question, answeredIds: [Int]) -> QuestionViewerViewController {
        let vc = QuestionViewerViewController(question: question, answeredIds: answeredIds)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: QuestionViewerTableDelegate
extension QuestionViewerViewController: QuestionViewerTableDelegate {
    func questionViewerTableDidExpand(contentType: QuestionContentCollectionType) {
        switch contentType {
        case let .image(url):
            let controller = PhotoViewController.make(imageURL: url)
            present(controller, animated: true)
        case let .video(url):
            let controller = AVPlayerViewController()
            controller.view.backgroundColor = UIColor.black
            let player = AVPlayer(url: url)
            controller.player = player
            present(controller, animated: true) { [weak player] in
                player?.play()
            }
        }
    }
}

// MARK: Private
private extension QuestionViewerViewController {
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    func update(favorite: Bool) {
        let image = UIImage(named: favorite ? "TestViewer.Favorite.Check" : "TestViewer.Favorite.Uncheck")
        mainView.favoriteButton.setImage(image, for: .normal)
    }
}
