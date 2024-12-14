//
//  LRContainerView.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import UIKit

class LRContainerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContainerView() {
        self.backgroundColor = .containerBg
        self.tintColor = .containerForeground
    }
}
