//
//  VideoCreatorView.swift
//  LRVideoPlayer
//
//  Created by Veena on 15/12/24.
//

import UIKit

class VideoCreatorView: LRContainerView {
    // UI Elements
    private let picImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let likeImageView = UIImageView()
    private let likesLabel = UILabel()
    private let followButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(profileImageURL: URL?, username: String, likes: Int) {
        picImageView.kf.setImage(with: profileImageURL)
        usernameLabel.text = username
        likesLabel.text = "\(likes)"
    }
    
    func reset() {
        picImageView.image = nil
        usernameLabel.text = ""
        likesLabel.text = ""
        followButton.setTitle(K.Labels.follow, for: .normal)
    }
}

// MARK: - Setup
extension VideoCreatorView {
    private func setupView() {
        layer.cornerRadius = 8
        clipsToBounds = true
        
        picImageView.contentMode = .scaleAspectFill
        picImageView.clipsToBounds = true
        picImageView.layer.cornerRadius = 6
        
        usernameLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        usernameLabel.textColor = .containerForeground
        
        likeImageView.contentMode = .scaleAspectFit
        likeImageView.image = UIImage(named: "like_icon")
        likeImageView.tintColor = .containerForeground
        
        likesLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        likesLabel.textColor = .containerForeground
        
        followButton.setTitle(K.Labels.follow, for: .normal)
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        followButton.setTitleColor(.white, for: .normal)
        followButton.backgroundColor = .followBg
        followButton.layer.cornerRadius = 8
        
        
        let likesStack = UIStackView()
        likesStack.axis = .horizontal
        likesStack.spacing = 1
        likesStack.alignment = .center
        likesStack.addArrangedSubview(likeImageView)
        likesStack.addArrangedSubview(likesLabel)
        
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 0
        verticalStack.alignment = .leading
        verticalStack.addArrangedSubview(usernameLabel)
        verticalStack.addArrangedSubview(likesStack)
        
        let mainStack = UIStackView()
        mainStack.axis = .horizontal
        mainStack.spacing = 4
        mainStack.alignment = .center
        mainStack.addArrangedSubview(picImageView)
        mainStack.addArrangedSubview(verticalStack)
        mainStack.addArrangedSubview(followButton)
        
        mainStack.setCustomSpacing(2, after: picImageView)
        
        addSubview(mainStack)
        
        picImageView.translatesAutoresizingMaskIntoConstraints = false
        followButton.translatesAutoresizingMaskIntoConstraints = false
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picImageView.widthAnchor.constraint(equalToConstant: 22),
            picImageView.heightAnchor.constraint(equalToConstant: 22),
            
            followButton.widthAnchor.constraint(equalToConstant: 84),
            followButton.heightAnchor.constraint(equalToConstant: 22),
            
            likeImageView.widthAnchor.constraint(equalToConstant: 9),
            likeImageView.heightAnchor.constraint(equalToConstant: 9),
            
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }
}
