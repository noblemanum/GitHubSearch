//
//  UserController.swift
//  GithubSearch
//
//  Created by Dimon on 07.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation

class UserController {
    
    func fetchUser(with username: String, completion: @escaping (FullUser?) -> Void) {

            let url = URL(string: "https://api.github.com/users/\(username)")!
            
            print(url)

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let user: FullUser = Decoder.decode(data: data) {
                    DispatchQueue.main.async {
                        completion(user)
                    }
                }
            }

            task.resume()
        }
}
