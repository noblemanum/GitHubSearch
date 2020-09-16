//
//  URL+Helpers.swift
//  GithubSearch
//
//  Created by Dimon on 05.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//


import Foundation

extension URL {
    func withQueries(_ query: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = query.map { URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}
