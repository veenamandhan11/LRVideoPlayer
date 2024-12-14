//
//  VideoOverlayView.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import UIKit

class VideoOverlayView: UIView {
    private let creatorView = VideoCreatorView()
    private let viewsCountView = VideoViewersView()
    
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
    }
}

// MARK: - UI Setup
extension VideoOverlayView {
    private func setupView() {
        let commentsView = CommentsView()
        commentsView.backgroundColor = .clear
        
        addSubview(creatorView)
        addSubview(viewsCountView)
        addSubview(commentsView)
        
        creatorView.translatesAutoresizingMaskIntoConstraints = false
        commentsView.translatesAutoresizingMaskIntoConstraints = false
        viewsCountView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            creatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            creatorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            creatorView.trailingAnchor.constraint(lessThanOrEqualTo: viewsCountView.leadingAnchor, constant: -16),
            creatorView.heightAnchor.constraint(equalToConstant: 26),
            
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
}
