//
//  CommentsView.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import UIKit

class CommentsView: UIView {
    private let viewModel = CommentsViewModel()
    
    private let tableView = UITableView()
    private let textField = PaddedTextField(padding: UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11))
    private let trailingImageView = UIImageView()
    
    private var isProgrammaticallyScrolling = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        loadComments()
        registerKeyboardNotifications()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unregisterKeyboardNotifications()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let gradientLayer = layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }
    
    private func loadComments() {
        viewModel.loadComments { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.viewModel.startAddingComments { [weak self] in
                        self?.tableView.reloadData()
                        self?.alignTableViewToBottom()
                        self?.scrollToBottom(animated: true)
                    }
                } else {
                    print("Failed to load comments.")
                }
            }
        }
    }
    
    private func scrollToBottom(animated: Bool) {
        let lastRow = tableView.numberOfRows(inSection: 0) - 1
        if lastRow >= 0 {
            isProgrammaticallyScrolling = true
            tableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: animated)
            isProgrammaticallyScrolling = false
            adjustCellOpacity()
        }
    }
    
    @objc private func textFieldDidChange() {
        let hasText = !(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        trailingImageView.image = hasText ? UIImage(systemName: "paperplane") : UIImage(named: "emoji_outline")
    }
    
    @objc private func didPressSend() {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
        viewModel.addComment(text)
        
        textField.text = ""
        trailingImageView.image = UIImage(named: "emoji_outline")
        
        tableView.reloadData()
        scrollToBottom(animated: true)
    }
    
    private func alignTableViewToBottom(animated: Bool = true) {
        let contentHeight = tableView.contentSize.height
        let tableHeight = tableView.bounds.height
        
        let newTopInset: CGFloat
        if contentHeight < tableHeight {
            newTopInset = tableHeight - contentHeight
        } else {
            newTopInset = 64
        }
        let newInset = UIEdgeInsets(top: newTopInset, left: 0, bottom: 16, right: 0)
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.contentInset = newInset
                self.tableView.layoutIfNeeded()
            })
        } else {
            tableView.contentInset = newInset
        }
    }
}

// MARK: - UI Setup
extension CommentsView {
    private func setupView() {
        setupGradientBackground()
        setupTextField()
        setupTableView()
        setupTrailingImageView()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: K.Size.commentSectionHeight-16, left: 0, bottom: 16, right: 0)
        addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26),
            tableView.bottomAnchor.constraint(equalTo: textField.topAnchor)
        ])
    }
    
    private func setupTextField() {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: K.Labels.comment, attributes: placeholderAttributes)
        
        textField.layer.cornerRadius = 17
        textField.backgroundColor = .commentTextField
        textField.returnKeyType = .send
        textField.delegate = self
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13),
            textField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant: 34)
        ])
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(didPressSend), for: .editingDidEndOnExit)
    }
    
    private func setupTrailingImageView() {
        trailingImageView.image = UIImage(named: "emoji_outline")
        trailingImageView.tintColor = .white
        trailingImageView.contentMode = .scaleAspectFit
        
        trailingImageView.isUserInteractionEnabled = true
        let sendTap = UITapGestureRecognizer(target: self, action: #selector(didPressSend))
        trailingImageView.addGestureRecognizer(sendTap)
        
        addSubview(trailingImageView)
        trailingImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailingImageView.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -11),
            trailingImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            trailingImageView.widthAnchor.constraint(equalToConstant: 18),
            trailingImageView.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(0.5).cgColor,
            UIColor.black.withAlphaComponent(0.75).cgColor
        ]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - Table View Delegate
extension CommentsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfDisplayedComments()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath) as! CommentCell
        if let comment = viewModel.comment(at: indexPath.row) {
            cell.configure(with: comment)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isProgrammaticallyScrolling { return }
        adjustCellOpacity()
    }
    
    private func adjustCellOpacity() {
        let fadeHeight = tableView.frame.height * 0.2 // Top 20% fading zone

        for cell in tableView.visibleCells {
            guard let cellFrame = cell.superview?.convert(cell.frame, to: self) else { continue }
            let distanceFromTop = fadeHeight - cellFrame.origin.y

            if distanceFromTop > 0 {
                let alpha = max(0, 1.0 - (distanceFromTop / fadeHeight))
                cell.alpha = alpha
            } else {
                cell.alpha = 1.0
            }
        }
    }
}

// MARK: - Keyboard Activity
extension CommentsView {
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: animationDuration) {
            self.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight+8)
        }
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        UIView.animate(withDuration: animationDuration) {
            self.transform = .identity
        }
    }
}

extension CommentsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didPressSend()
        return false
    }
}
