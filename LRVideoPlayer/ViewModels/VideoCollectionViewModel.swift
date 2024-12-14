//
//  VideoViewModel.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import Foundation

class VideoCollectionViewModel {
    private(set) var videos: [Video] = []
    
    func loadVideos(completion: @escaping (Bool) -> Void) {
        guard let path = Bundle.main.path(forResource: "mockVideos", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("Failed to load JSON file.")
            completion(false)
            return
        }
        do {
            let videoResponse = try JSONDecoder().decode(VideoResponse.self, from: data)
            self.videos = videoResponse.videos
            completion(true)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(false)
        }
    }
    
    func video(at index: Int) -> Video? {
        guard index >= 0 && index < videos.count else { return nil }
        return videos[index]
    }
    
    func numberOfVideos() -> Int {
        return videos.count
    }
}
