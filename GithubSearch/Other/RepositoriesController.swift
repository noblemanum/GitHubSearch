//
//  RepositoriesController.swift
//  GithubSearch
//
//  Created by Dimon on 05.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation

class RepositoriesController {
    
    func fetchRepositories(matching query: [String: String], completion: @escaping (Repositories?) -> Void) {

        let baseURL = URL(string: "https://api.github.com/search/repositories")!

        guard let url = baseURL.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        print(url)

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                        
            if let repositories: Repositories = Decoder.decode(data: data) {
                DispatchQueue.main.async {
                    completion(repositories)
                }
            }
        }

        task.resume()
    }
}
