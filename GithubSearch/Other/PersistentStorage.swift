//
//  PersistentStorage.swift
//  GithubSearch
//
//  Created by Dimon on 08.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation
import CoreData

class PersistentStorage {
    
    static let shared = PersistentStorage()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GithubSearch")
        container.loadPersistentStores(completionHandler: { (_, _) in })
        return container
    }()
}
