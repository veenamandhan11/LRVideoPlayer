//
//  ViewController.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import UIKit

class ViewController: UIViewController {
    private let viewModel = VideoCollectionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideos()
    }
    
    private func loadVideos() {
        viewModel.loadVideos { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    print(self.viewModel.numberOfVideos())
                }
            } else {
                print("Failed to load videos.")
            }
        }
    }
}
