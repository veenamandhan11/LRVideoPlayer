//
//  Comment.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import Foundation

struct Comment: Decodable {
    let id: Int
    let username: String
    let picURL: String
    let comment: String
    
    var picURLObject: URL? {
        return URL(string: picURL)
    }
}

struct CommentResponse: Decodable {
    let comments: [Comment]
}
