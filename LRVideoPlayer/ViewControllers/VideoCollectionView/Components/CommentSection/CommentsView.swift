//
//  CommentsView.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import UIKit

class CommentsView: UIView {
    private let viewModel = CommentsViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadComments()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadComments() {
        viewModel.loadComments { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    print(self.viewModel.numberOfDisplayedComments())
                }
            } else {
                print("Failed to load videos.")
            }
        }
    }
}
