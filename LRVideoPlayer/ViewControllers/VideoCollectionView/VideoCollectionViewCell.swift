//
//  VideoCollectionViewCell.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import AVKit

class VideoCollectionViewCell: UICollectionViewCell {
    static let identifier = "VideoCollectionViewCell"

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPlayer() {
        playerLayer = AVPlayerLayer()
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = contentView.bounds
        if let layer = playerLayer {
            contentView.layer.addSublayer(layer)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = contentView.bounds
    }

    func configure(with videoURL: String) {
        if let url = URL(string: videoURL) {
            player = AVPlayer(url: url)
            playerLayer?.player = player
            play()
        }
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func seekToStart() {
        player?.seek(to: .zero)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pause()
        player = nil
        playerLayer?.player = nil
    }
}
