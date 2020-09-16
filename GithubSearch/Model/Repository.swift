//
//  Repository.swift
//  GithubSearch
//
//  Created by Dimon on 05.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation
import UIKit

struct Repository: Codable {
    var repositoryFullName: String
    var description: String?
    var owner: User
    
    enum CodingKeys: String, CodingKey {
        case repositoryFullName = "full_name"
        case description
        case owner
    }
}

struct Repositories: Codable {
    let totalCount: Int
    let items: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

struct SelectedRepository {
    let repositoryName: String?
    let repositoryDescription: String?
    let login: String?
    let username: String?
    let email: String?
    let image: Data?
}
