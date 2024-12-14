//
//  Video.swift
//  LRVideoPlayer
//
//  Created by Veena on 14/12/24.
//

import Foundation

struct Video: Decodable {
    let id: Int
    let userID: Int
    let username: String
    let profilePicURL: String
    let description: String
    let topic: String
    let viewers: Int
    let likes: Int
    let video: String
    let thumbnail: String
}

struct VideoResponse: Decodable {
    let videos: [Video]
}
