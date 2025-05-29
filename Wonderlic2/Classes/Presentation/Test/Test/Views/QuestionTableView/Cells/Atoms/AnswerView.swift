//
//  AnswerView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import UIKit
import RxCocoa
import Kingfisher

final class AnswerView: UIView {
    enum State {
        case initial, correct, error, warning, selected
    }
    
    var state: State = .initial {
        didSet {
            setState(state: state)
        }
    }
    
    lazy var markLabel = makeLabel()
    lazy var iconView = makeIconView()
    lazy var answerLabel = makeLabel()
    lazy var imageView = makeImageView()
    lazy var preloader = makePreloader()
    
    private lazy var tapGesture = UITapGestureRecognizer()
    
    private lazy var labelBottomConstraint = NSLayoutConstraint()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension AnswerView {
    func setAnswer(mark: String, answer: String, image: URL?) {
        answerLabel.attributedText = answer
            .attributed(with: TextAttributes()
                            .font(Fonts.Inter.regular(size: 15.scale))
                            .textColor(Appearance.mono200)
                            .lineHeight(22.5.scale)
                            .letterSpacing(-0.14.scale))
        
        setup(mark: mark, image: image)
    }
    
    func setAnswer(mark: String, answerHtml: String, image: URL?) {
        answerLabel.attributedText = attributedString(for: answerHtml)
        
        setup(mark: mark, image: image)
    }
    
    var didTap: Signal<Void> {
        tapGesture.rx.event
            .map { _ in () }
            .asSignal(onErrorSignalWith: .empty())
    }
}

// MARK: Private
private extension AnswerView {
    func initialize() {
        layer.cornerRadius = 10.scale
        addGestureRecognizer(tapGesture)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 6.scale
        
        state = .initial
    }
    
    func setup(mark: String, image: URL?) {
        markLabel.attributedText = mark
            .attributed(with: TextAttributes()
                            .font(Fonts.Inter.regular(size: 15.scale))
                            .textColor(Appearance.mono300)
                            .lineHeight(22.5.scale)
                            .letterSpacing(-0.14.scale))
        
        imageView.image = nil
        imageView.kf.cancelDownloadTask()
        preloader.stopAnimating()
        
        if let imageUrl = image {
            preloader.startAnimating()
        
            imageView.kf.setImage(with: imageUrl, completionHandler: { [weak self] _ in
                self?.preloader.stopAnimating()
            })
            
            needUpdateConstraints()
        }
    }
    
    func setState(state: State) {
        switch state {
        case .initial:
            layer.shadowOpacity = 0.08
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
            backgroundColor = Appearance.mono100
            iconView.image = nil
            markLabel.textColor = Appearance.mono300
        case .selected:
            layer.shadowOpacity = 0
            layer.borderWidth = 1.scale
            layer.borderColor = Appearance.main300.cgColor
            backgroundColor = Appearance.main300.withAlphaComponent(0.1)
            iconView.image = nil
            markLabel.textColor = Appearance.main300
        case .correct:
            layer.shadowOpacity = 0
            layer.borderWidth = 1.scale
            layer.borderColor = Appearance.system200.cgColor
            backgroundColor = Appearance.system200.withAlphaComponent(0.2)
            iconView.image = UIImage(named: "Question.Correct")
            iconView.tintColor = Appearance.system200
            markLabel.textColor = UIColor.clear
        case .error:
            layer.shadowOpacity = 0
            layer.borderWidth = 1.scale
            layer.borderColor = Appearance.system100.cgColor
            backgroundColor = Appearance.system100.withAlphaComponent(0.2)
            iconView.image = UIImage(named: "Question.Error")
            iconView.tintColor = Appearance.system100
            markLabel.textColor = UIColor.clear
        case .warning:
            layer.shadowOpacity = 0
            layer.borderWidth = 1.scale
            layer.borderColor = Appearance.main500.cgColor
            backgroundColor = Appearance.main500.withAlphaComponent(0.2)
            iconView.image = UIImage(named: "Question.Warning")
            iconView.tintColor = Appearance.main500
            markLabel.textColor = UIColor.clear
        }
    }
    
    func attributedString(for htmlString: String) -> NSAttributedString? {
        guard !htmlString.isEmpty else { return nil }
        
        let font = Fonts.Inter.regular(size: 15.scale)
        let htmlWithStyle = "<span style=\"font-family: \(font.fontName); font-style: regular; font-size: \(15.scale); line-height: \(22.5.scale)px;\">\(htmlString)</span>"
        let data = Data(htmlWithStyle.utf8)
        
        let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
        
        return attributedString
    }
}

// MARK: Make constraints
private extension AnswerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            answerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            answerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            answerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18.scale)
        ])
        
        labelBottomConstraint = answerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18.scale)
        labelBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            markLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            markLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale)
        ])
    }
    
    func needUpdateConstraints() {
        labelBottomConstraint.isActive = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 124.scale),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44.scale),
            imageView.trailingAnchor.constraint(equalTo: iconView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        labelBottomConstraint = imageView.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 10.scale)
        labelBottomConstraint.isActive = true
    }
}

// MARK: Lazy initialization
private extension AnswerView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 24.scale, height: 24.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
