//
//  PhotoViewController.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import UIKit
import Kingfisher

final class PhotoViewController: UIViewController {
    private var imageURL: URL?
    
    var imageScrollView: ImageScrollView!
    
    private var image: UIImage?
    
    convenience init(image: UIImage) {
        self.init()
        
        self.image = image
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageScrollView)
        
        setupImageScrollView()
        view.backgroundColor = .black
        
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.imageScrollView.set(image: image)
                    }
                }
            }
        }
    }
}

// MARK: Make
extension PhotoViewController {
    static func make(imageURL: URL) -> PhotoViewController {
        let controller = PhotoViewController()
        controller.imageURL = imageURL
        return controller
    }
}

// MARK: Private
private extension PhotoViewController {
    func setupImageScrollView() {
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}
