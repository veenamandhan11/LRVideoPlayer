//
//  VideoCollectionViewController.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import UIKit

class VideoCollectionViewController: UIViewController {
    private let viewModel = VideoCollectionViewModel()
    
    private var collectionView: UICollectionView!
    
    private var currentPlayingCell: VideoCollectionViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        loadVideos()
    }
    
    private func loadVideos() {
        viewModel.loadVideos { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.layoutIfNeeded()
                    self.playMostVisibleCell()
                }
            } else {
                self.showToast(K.Errors.failedToLoadVideos)
            }
        }
    }
}

// MARK: - UI Setup
extension VideoCollectionViewController {
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = view.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)

        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - Collection View
extension VideoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfVideos()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as! VideoCollectionViewCell
        if let video = viewModel.video(at: indexPath.item) {
            cell.configure(with: video)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? VideoCollectionViewCell {
            cell.pause()
            cell.seekToStart()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        playMostVisibleCell()
    }
    
    private func playMostVisibleCell() {
        if let mostVisibleCell = collectionView.getMostVisibleCell() as? VideoCollectionViewCell {
            if currentPlayingCell !== mostVisibleCell {
                currentPlayingCell?.pause()
                mostVisibleCell.play()
                currentPlayingCell = mostVisibleCell
            }
        }
    }
}
