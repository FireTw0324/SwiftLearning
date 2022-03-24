//
//  findMyfriend.swift
//  FBDemo
//
//  Created by student on 2022/1/17.
//

import Foundation

//:[{"id":"490","friendName":"Lee","lat":"21.123456","lon":"121.123456","lastUpdateDateTime":"2022-01-17
struct Post: Codable {
    let result: Bool
    let friends: [Friend]
    
}
// MARK: - Friend
struct Friend: Codable {
    let id, friendName, lat, lon: String
    let lastUpdateDateTime: String
}



























