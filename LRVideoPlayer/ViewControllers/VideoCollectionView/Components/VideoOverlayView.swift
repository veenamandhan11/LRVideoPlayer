//
//  VideoOverlayView.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import UIKit

class VideoOverlayView: UIView {
    private let creatorView = VideoCreatorView()
    private let commentsView = CommentsView()
    private let viewsCountView = VideoViewersView()
    private let topicView = VideoTopicView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(video: Video) {
        creatorView.configure(profileImageURL: video.profilePicURLObject, username: video.username, likes: video.likes)
        viewsCountView.configure(viewsCount: video.viewers)
        topicView.configure(topic: video.topic)
    }
    
    func play() {
        commentsView.play()
    }
    
    func reset() {
        creatorView.reset()
        commentsView.reset()
        viewsCountView.reset()
        topicView.reset()
    }
}

// MARK: - UI Setup
extension VideoOverlayView {
    private func setupView() {
        commentsView.backgroundColor = .clear
        
        setupGradientBackground()
        
        addSubview(creatorView)
        addSubview(viewsCountView)
        addSubview(topicView)
        addSubview(commentsView)
        
        creatorView.translatesAutoresizingMaskIntoConstraints = false
        topicView.translatesAutoresizingMaskIntoConstraints = false
        commentsView.translatesAutoresizingMaskIntoConstraints = false
        viewsCountView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            creatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            creatorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            creatorView.trailingAnchor.constraint(lessThanOrEqualTo: viewsCountView.leadingAnchor, constant: -16),
            creatorView.heightAnchor.constraint(equalToConstant: 26),
            
            topicView.leadingAnchor.constraint(equalTo: creatorView.leadingAnchor),
            topicView.topAnchor.constraint(equalTo: creatorView.bottomAnchor, constant: 6),
            topicView.heightAnchor.constraint(equalToConstant: 15),
            
            viewsCountView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            viewsCountView.centerYAnchor.constraint(equalTo: creatorView.centerYAnchor),
            viewsCountView.heightAnchor.constraint(equalToConstant: 15),
            
            commentsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            commentsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            commentsView.heightAnchor.constraint(equalToConstant: K.Size.commentSectionHeight),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: K.Size.screenWidth, height: 153)
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.5).cgColor,
            UIColor.black.withAlphaComponent(0.2).cgColor,
            UIColor.black.withAlphaComponent(0).cgColor
        ]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
