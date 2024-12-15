//
//  VideoCollectionViewCell.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import AVKit

class VideoCollectionViewCell: UICollectionViewCell {
    static let identifier = K.CellIdentifiers.videoCollectionViewCell

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let overlayView = VideoOverlayView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayer()
        setupOverlayView()
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

    func configure(with video: Video) {
        overlayView.configure(video: video)
        if let url = video.videoURLObject {
            player = AVPlayer(url: url)
            playerLayer?.player = player
            setupLooping()
        }
    }
    
    private func setupLooping() {
        NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    @objc private func loopVideo() {
        seekToStart()
        player?.play()
    }
    
    func play() {
        player?.play()
        overlayView.play()
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
        NotificationCenter.default.removeObserver(self)
        overlayView.reset()
    }

    private func setupOverlayView() {
        contentView.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
