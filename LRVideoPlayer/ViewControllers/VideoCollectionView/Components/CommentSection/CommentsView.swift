//
//  CommentsView.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import UIKit

protocol CommentsViewDelegate: AnyObject {
    func showToastMessage(_ message: String)
}

class CommentsView: UIView {
    weak var delegate: CommentsViewDelegate?
    private var viewModel: CommentsViewModel?
    
    private let tableView = UITableView()
    private let textField = PaddedTextField(padding: UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11))
    private let sendImageView = UIImageView()
    
    private var isProgrammaticallyScrolling = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
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
        viewModel?.loadComments { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.viewModel?.startAddingComments { [weak self] in
                        self?.tableView.reloadData()
                        self?.scrollToBottomIfNeeded(animated: true)
                        self?.alignTableViewToBottom()
                    }
                } else {
                    self.delegate?.showToastMessage(K.Errors.failedToLoadComments)
                }
            }
        }
    }
    
    @objc private func didPressSend() {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
        viewModel?.addComment(text)
        
        textField.text = ""
        sendImageView.isHidden = true
        
        tableView.reloadData()
        scrollToBottom(animated: true)
    }
    
    // MARK: - Public methods
    func play() {
        if viewModel == nil {
            viewModel = CommentsViewModel()
            loadComments()
        }
    }
    
    func reset() {
        textField.text = ""
        sendImageView.isHidden = true
        resetTableViewInset()
        viewModel = nil
        tableView.reloadData()
    }
}

// MARK: - Table View Delegate
extension CommentsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfDisplayedComments() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath) as! CommentCell
        if let comment = viewModel?.comment(at: indexPath.row) {
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

// MARK: - TextField Delegate
extension CommentsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didPressSend()
        return false
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
        resetTableViewInset()
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
        // Placeholder font and color
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.7),
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: K.Labels.comment, attributes: placeholderAttributes)
        
        // User-entered text font
        textField.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        textField.textColor = .white
        textField.tintColor = .white
        
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
        sendImageView.image = K.Images.paperplane
        sendImageView.tintColor = .white
        sendImageView.contentMode = .scaleAspectFit
        sendImageView.isHidden = true
        
        sendImageView.isUserInteractionEnabled = true
        let sendTap = UITapGestureRecognizer(target: self, action: #selector(didPressSend))
        sendImageView.addGestureRecognizer(sendTap)
        
        addSubview(sendImageView)
        sendImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendImageView.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -11),
            sendImageView.widthAnchor.constraint(equalToConstant: 22),
            sendImageView.topAnchor.constraint(equalTo: textField.topAnchor),
            sendImageView.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
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

// MARK: - UI Helpers
extension CommentsView {
    private func isTableViewAtBottom() -> Bool {
        let offsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let tableHeight = tableView.bounds.size.height
        return contentHeight - tableHeight - offsetY <= 100
    }
    
    private func scrollToBottomIfNeeded(animated: Bool) {
        // If user has scrolled up manually, then don't scroll to bottom
        guard isTableViewAtBottom() else { return }
        scrollToBottom(animated: animated)
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
        sendImageView.isHidden = !hasText
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
    
    private func resetTableViewInset() {
        let safeAreaInsetsBottom = K.safeAreaInsets?.bottom ?? 0
        let textFieldHeight: CGFloat = 34
        let tableViewBottomInset: CGFloat = 16
        let tableViewTopInset: CGFloat = 64
        let maxTop = K.Size.screenHeight - safeAreaInsetsBottom - textFieldHeight - tableViewBottomInset - tableViewTopInset
        
        tableView.contentInset = UIEdgeInsets(top: maxTop, left: 0, bottom: tableViewBottomInset, right: 0)
    }
}
