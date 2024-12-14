//
//  Constants.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import UIKit

enum K {
    enum Labels {
        static let comment = "Comment"
        static let follow = "+ Follow"
    }
    
    enum Errors {
        static let failedToLoadVideos = "Failed to load videos"
        static let failedToLoadComments = "Failed to load comments"
    }
    
    enum Size {
        static let screenBounds = UIScreen.main.bounds
        static let screenWidth = screenBounds.width
        static let screenHeight = screenBounds.height
        
        static let commentSectionHeight = screenBounds.height*0.4
    }
}
