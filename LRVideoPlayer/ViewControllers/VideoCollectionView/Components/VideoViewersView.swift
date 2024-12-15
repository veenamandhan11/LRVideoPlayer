//
//  VideoViewersView.swift
//  LRVideoPlayer
//
//  Created by Veena on 15/12/24.
//

import UIKit

class VideoViewersView: LRContainerView {
    private let iconImageView = UIImageView()
    private let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewsCount: Int) {
        countLabel.text = "\(viewsCount)"
    }
    
    func reset() {
        countLabel.text = "0"
    }
}

// MARK: - Setup
extension VideoViewersView {
    private func setupView() {
        layer.cornerRadius = 6
        clipsToBounds = true
        
        iconImageView.image = K.Images.person
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .containerForeground
        
        countLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        countLabel.textColor = .containerForeground
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.alignment = .center
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(countLabel)
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 11),
            iconImageView.heightAnchor.constraint(equalToConstant: 10),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }
}
