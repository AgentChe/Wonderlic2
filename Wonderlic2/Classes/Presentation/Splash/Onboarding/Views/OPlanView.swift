//
//  OPlanView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 10.03.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class OPlanView: OSlideView {
    weak var vc: UIViewController?
    weak var combineData: OnboardingCombineData?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var gridView = makeGridView()
    lazy var column1TitleLabel = makeColumn1TitleLabel()
    lazy var column1View = makeColumn1View()
    lazy var column1PeriodLabel = makeColumn1PeriodLabel()
    lazy var column2TitleLabel = makeColumn2TitleLabel()
    lazy var column2View = makeColumn2View()
    lazy var column2PeriodLabel = makeColumn2PeriodLabel()
    lazy var button = makeButton()
    
    private lazy var column1Height = NSLayoutConstraint()
    private lazy var column2Height = NSLayoutConstraint()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var tryAgainTrigger = PublishRelay<Void>()
    
    private lazy var profileManager = ProfileManager()
    private lazy var coursesManager = CoursesManager()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        change(enabled: false)
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        openUp()
    }
}

// MARK: Private
private extension OPlanView {
    func initialize() {
        backgroundColor = Appearance.main100
        
        Observable
            .merge(
                button.rx.tap.asObservable(),
                tryAgainTrigger.asObservable()
            )
            .flatMapLatest { [weak self] _ -> Single<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                guard let combineData = self.combineData?.combineData() else {
                    return .never()
                }
                
                return profileManager
                    .set(
                        motivation: combineData.motivation.code,
                        examDate: combineData.examDate,
                        testMode: combineData.studyMode.code,
                        testMinutes: combineData.testMinutes,
                        testDaysOfWeek: combineData.testDays,
                        course: combineData.course
                    )
                    .map { true }
                    .catchAndReturn(false)
            }
            .subscribe(onNext: { [weak self] success in
                guard let self = self else {
                    return
                }
                
                success ? self.onNext() : self.openError()
            })
            .disposed(by: disposeBag)
    }
    
    func openError() {
        let tryAgainVC = TryAgainViewController.make { [weak self] in
            guard let self = self else {
                return
            }
            
            self.tryAgainTrigger.accept(Void())
        }
        vc?.present(tryAgainVC, animated: true)
    }
    
    func prepare() {
        gridView.alpha = 0
        column1TitleLabel.alpha = 0
        column1PeriodLabel.alpha = 0
        column2TitleLabel.alpha = 0
        column2PeriodLabel.alpha = 0
    }
    
    func openUp() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.gridView.alpha = 1
        }, completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.showPeriods()
        })
    }
    
    func showPeriods() {
        UIView.animate(withDuration: 1, animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.column1PeriodLabel.alpha = 1
            self.column2PeriodLabel.alpha = 1
        }, completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.showColumns()
        })
    }
    
    func showColumns() {
        column1Height.constant = 60.scale
        column2Height.constant = 182.scale
        
        UIView.animate(withDuration: 2, animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.layoutIfNeeded()
        }, completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.showTitles()
        })
    }
    
    func showTitles() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.column1TitleLabel.alpha = 1
            self.column2TitleLabel.alpha = 1
        }, completion: { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.change(enabled: true)
        })
    }
    
    func change(enabled: Bool) {
        button.isEnabled = enabled
        button.alpha = enabled ? 1 : 0.2
    }
}

// MARK: Make constraints
private extension OPlanView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant:ScreenSize.isIphoneXFamily ? 126.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            gridView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridView.heightAnchor.constraint(equalToConstant: 186.scale),
            gridView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 77.scale)
        ])
        
        NSLayoutConstraint.activate([
            column1TitleLabel.centerXAnchor.constraint(equalTo: column1View.centerXAnchor),
            column1TitleLabel.bottomAnchor.constraint(equalTo: column1View.topAnchor, constant: -12.scale)
        ])
        
        column1Height = column1View.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            column1View.widthAnchor.constraint(equalToConstant: 82.scale),
            column1Height,
            column1View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 102.scale),
            column1View.bottomAnchor.constraint(equalTo: gridView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            column1PeriodLabel.centerXAnchor.constraint(equalTo: column1View.centerXAnchor),
            column1PeriodLabel.topAnchor.constraint(equalTo: column1View.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            column2TitleLabel.centerXAnchor.constraint(equalTo: column2View.centerXAnchor),
            column2TitleLabel.bottomAnchor.constraint(equalTo: column2View.topAnchor, constant: -12.scale)
        ])
        
        column2Height = column2View.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            column2View.widthAnchor.constraint(equalToConstant: 82.scale),
            column2Height,
            column2View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 225.scale),
            column2View.bottomAnchor.constraint(equalTo: gridView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            column2PeriodLabel.centerXAnchor.constraint(equalTo: column2View.centerXAnchor),
            column2PeriodLabel.topAnchor.constraint(equalTo: column2View.bottomAnchor, constant: 12.scale)
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
private extension OPlanView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 28.scale))
            .lineHeight(33.6.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.PlanView.Title".localized.attributed(with: attrs)
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
        view.attributedText = "Onboarding.PlanView.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGridView() -> OPlanGridView {
        let view = OPlanGridView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeColumn1TitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semiBold(size: 15.scale))
            .lineHeight(18.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.PlanView.Column1.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeColumn1View() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 8.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeColumn1PeriodLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.4))
            .font(Fonts.Inter.semiBold(size: 15.scale))
            .lineHeight(22.5.scale)
            .letterSpacing(-0.14.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.PlanView.Column1.Period".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeColumn2TitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.Inter.semiBold(size: 15.scale))
            .lineHeight(18.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.PlanView.Column2.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeColumn2View() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 8.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeColumn2PeriodLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.4))
            .font(Fonts.Inter.semiBold(size: 15.scale))
            .lineHeight(22.5.scale)
            .letterSpacing(-0.14.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.PlanView.Column2.Period".localized.attributed(with: attrs)
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
        view.setAttributedTitle("Onboarding.PlanView.Button".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main300
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
