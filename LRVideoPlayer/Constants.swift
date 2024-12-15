//
//  Constants.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import UIKit

enum K {
    static let scenes = UIApplication.shared.connectedScenes
    static let windowScene = scenes.first as? UIWindowScene
    static let window = windowScene?.windows.first
    static let safeAreaInsets = window?.safeAreaInsets
    
    enum Labels {
        static let comment = "Comment"
        static let follow = "+ Follow"
    }
    
    enum Placeholder {
        static let username = "anonymous"
        static let profilePicUrl = "https://i.sstatic.net/l60Hf.png"
    }
    
    enum Errors {
        static let failedToLoadVideos = "Failed to load videos"
        static let failedToLoadComments = "Failed to load comments"
        static let failedToLoadJson = "Failed to load JSON file."
        static let errorDecodingJson = "Error decoding JSON."
    }
    
    enum Size {
        static let screenBounds = UIScreen.main.bounds
        static let screenWidth = screenBounds.width
        static let screenHeight = screenBounds.height
        
        static let commentSectionHeight = screenBounds.height*0.4
    }
    
    enum Jsons {
        static let mockVideos = "mockVideos"
        static let mockComments = "mockComments"
    }
    
    enum CellIdentifiers {
        static let videoCollectionViewCell = "VideoCollectionViewCell"
        static let commentCell = "CommentCell"
    }
    
    enum Images {
        static let likeIcon = UIImage(named: "like_icon")
        static let person = UIImage(named: "person")
        static let starComment = UIImage(named: "star_comment")
        
        // System images
        static let paperplane = UIImage(systemName: "paperplane")
    }
}
