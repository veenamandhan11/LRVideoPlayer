//
//  CommentsViewModel.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import Foundation

class CommentsViewModel {
    private(set) var comments: [Comment] = []
    private(set) var displayedComments: [Comment] = []
    private var timer: Timer?
    
    func loadComments(completion: @escaping (Bool) -> Void) {
        guard let path = Bundle.main.path(forResource: "mockComments", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("Failed to load JSON file.")
            completion(false)
            return
        }
        
        do {
            let commentResponse = try JSONDecoder().decode(CommentResponse.self, from: data)
            self.comments = commentResponse.comments
            completion(true)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(false)
        }
    }
    
    func comment(at index: Int) -> Comment? {
        guard index >= 0 && index < displayedComments.count else { return nil }
        return displayedComments[index]
    }
    
    func numberOfDisplayedComments() -> Int {
        return displayedComments.count
    }
    
    func addComment(_ commentText: String) {
        let newComment = Comment(id: 1800 + comments.count, username: "anonymous", picURL: "https://i.sstatic.net/l60Hf.png", comment: commentText)
        displayedComments.append(newComment)
    }
}

// MARK: - Handles displaying comments every 2 seconds
extension CommentsViewModel {
    func startAddingComments(interval: TimeInterval = 2.0, updateHandler: @escaping () -> Void) {
        var currentIndex = 0
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            if currentIndex < self.comments.count {
                self.displayedComments.append(self.comments[currentIndex])
                currentIndex += 1
                updateHandler()
            } else {
                timer.invalidate()
            }
        }
    }
    
    func stopAddingComments() {
        timer?.invalidate()
        timer = nil
    }
}
