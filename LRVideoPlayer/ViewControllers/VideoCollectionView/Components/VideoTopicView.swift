//
//  VideoTopicView.swift
//  LRVideoPlayer
//
//  Created by Veena on 15/12/24.
//

import UIKit

class VideoTopicView: LRContainerView {
    private let iconImageView = UIImageView()
    private let topicLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(topic: String) {
        topicLabel.text = topic.capitalized
    }
    
    func reset() {
        topicLabel.text = ""
    }
}

// MARK: - UI Setup
extension VideoTopicView {
    private func setupView() {
        layer.cornerRadius = 6
        clipsToBounds = true
        
        iconImageView.image = K.Images.starComment
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .containerForeground
        
        topicLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        topicLabel.textColor = .white
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .center
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(topicLabel)
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 11),
            iconImageView.heightAnchor.constraint(equalToConstant: 11),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }
}
