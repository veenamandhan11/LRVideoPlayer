//
//  CommentCell.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import UIKit
import Kingfisher

class CommentCell: UITableViewCell {
    static let reuseIdentifier = K.CellIdentifiers.commentCell
    
    private let usernameLabel = UILabel()
    private let commentLabel = UILabel()
    private let picImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with comment: Comment) {
        usernameLabel.text = comment.username
        commentLabel.text = comment.comment
        picImageView.kf.setImage(with: comment.picURLObject)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        picImageView.kf.cancelDownloadTask()
        picImageView.image = nil
        usernameLabel.text = nil
        commentLabel.text = nil
    }
}

// MARK: - UI Setup
extension CommentCell {
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        picImageView.layer.cornerRadius = 14
        picImageView.contentMode = .scaleAspectFill
        picImageView.clipsToBounds = true
        picImageView.translatesAutoresizingMaskIntoConstraints = false
        
        usernameLabel.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        usernameLabel.textColor = .white.withAlphaComponent(0.7)
        
        commentLabel.font = UIFont.systemFont(ofSize: 9)
        commentLabel.numberOfLines = 0
        commentLabel.textColor = .white
        
        let textStackView = UIStackView(arrangedSubviews: [usernameLabel, commentLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 2
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalStackView = UIStackView(arrangedSubviews: [picImageView, textStackView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 6
        horizontalStackView.alignment = .top
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            picImageView.widthAnchor.constraint(equalToConstant: 28),
            picImageView.heightAnchor.constraint(equalToConstant: 28),
            
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
