//
//  User.swift
//  GithubSearch
//
//  Created by Dimon on 05.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation

struct User: Codable {
    var login: String
}

struct FullUser: Codable {
    var name: String?
    var email: String?
    var avatarURL: URL
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case avatarURL = "avatar_url"
    }
}
