//
//  VideoOverlayView.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import UIKit

class VideoOverlayView: UIView {
    private let commentsView = CommentsView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension VideoOverlayView {
    private func setupView() {
        commentsView.backgroundColor = .clear
        addSubview(commentsView)
        
        commentsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
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
