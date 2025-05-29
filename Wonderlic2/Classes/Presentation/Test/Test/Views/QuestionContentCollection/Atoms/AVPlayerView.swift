//
//  AVPlayerView.swift
//  ITExams
//
//  Created by Андрей Чернышев on 08.06.2022.
//

import UIKit
import AVFoundation

final class AVPlayerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
        
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
}

// MARK: Private
private extension AVPlayerView {
    func initialize() {
        backgroundColor = .black
        isUserInteractionEnabled = false
        clipsToBounds = true
        playerLayer.videoGravity = .resizeAspectFill
    }
}

