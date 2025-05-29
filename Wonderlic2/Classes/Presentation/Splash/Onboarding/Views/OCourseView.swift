//
//  OCourseView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 07.03.2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol OCourseViewDelegate: AnyObject {
    func courseViewDidSelected(course: Course)
}

final class OCourseView: OSlideView {
    weak var vc: UIViewController?
    var courseDelegates = [Weak<OCourseViewDelegate>]()
    
    lazy var backButton = makeBackButton()
    lazy var headerLabel = makeHeaderLabel()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var tableView = makeTableView()
    lazy var preloader = makePreloader()
    lazy var button = makeButton()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coursesManager = CoursesManager()
    
    private lazy var courses = [Course]()
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        changeEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        func source() -> Single<[Course]> {
            coursesManager
                .obtainCourses()
        }
        
        func trigger(error: Error) -> Observable<Void> {
            openError()
        }
        
        observableRetrySingle
            .retry(
                source: { source() },
                trigger: { trigger(error: $0) }
            )
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] courses in
                guard let self = self else { return }
                
                self.courses = courses
                
                let elements = courses.map { course in
                    OExamsTableElement(
                        code: String(course.id),
                        title: course.name,
                        subTitle: course.subTitle
                    )
                }
                
                self.tableView.setup(elements: elements)
                
                self.changeEnabled()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension OCourseView {
    func add(delegate: OCourseViewDelegate) {
        let weakly = delegate as AnyObject
        courseDelegates.append(Weak<OCourseViewDelegate>(weakly))
        courseDelegates = courseDelegates.filter { $0.weak != nil }
    }

    func remove(delegate: OCourseViewDelegate) {
        if let index = courseDelegates.firstIndex(where: { $0.weak === delegate }) {
            courseDelegates.remove(at: index)
        }
    }
}

// MARK: OExamsTableDelegate
extension OCourseView: OExamsTableDelegate {
    func examsTableDidChangeSelected() {
        changeEnabled()
    }
}

// MARK: Private
private extension OCourseView {
    func initialize() {
        backgroundColor = Appearance.main100
        
        button.rx.tap
            .bind(to: Binder(self) { base, void in
                guard let element = self.tableView.elements.first(where: { $0.isSelected }) else {
                    return
                }
                
                guard let course = self.courses.first(where: { $0.id == Int(element.code) }) else {
                    return
                }
                
                base.courseDelegates.forEach { $0.weak?.courseViewDidSelected(course: course) }
                
                base.onNext()
            })
            .disposed(by: disposeBag)
        
        activity
            .drive(Binder(preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
    
    func clear() {
        courses = []
        tableView.setup(elements: [])
    }
    
    func changeEnabled() {
        let isSelected = tableView.elements.contains(where: { $0.isSelected })
        
        button.isEnabled = isSelected
        button.alpha = isSelected ? 1 : 0.2
    }
    
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.vc?.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}

// MARK: Make constraints
private extension OCourseView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24.scale),
            backButton.heightAnchor.constraint(equalToConstant: 24.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 49.scale : 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 94.scale : 44.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 4.scale),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            button.heightAnchor.constraint(equalToConstant: 48.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OCourseView {
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "OCouse.Back"), for: .normal)
        view.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHeaderLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.Inter.bold(size: 17.scale))
            .lineHeight(20.4.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Course.Header".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 28.scale))
            .lineHeight(33.6.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Course.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono300)
            .font(Fonts.Inter.regular(size: 15.scale))
            .lineHeight(22.5.scale)
            .letterSpacing(-0.14.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Course.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> OExamsTable {
        let view = OExamsTable()
        view.mainDelegate = self
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 24.scale, left: 0, bottom: 24.scale, right: 0)
        view.separatorStyle = .none
        view.backgroundColor = UIColor.clear
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0.0
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .letterSpacing(-0.44.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Next".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
