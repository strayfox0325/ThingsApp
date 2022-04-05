//
//  User.swift
//  ThingsApp
//
//  Created by Isidora Lazic on 14.3.22..
//

import Foundation

struct User: Codable, Equatable {
    let userID: Int?
    let name: String?
    let email: String?
    let gender: String?
    let status: String?
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case name
        case email
        case gender
        case status
    }
}

