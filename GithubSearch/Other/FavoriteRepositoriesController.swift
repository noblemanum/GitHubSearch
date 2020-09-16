//
//  FavoriteRepositoriesController.swift
//  GithubSearch
//
//  Created by Dimon on 08.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoriteRepositoriesController {
    
    func save(favoriteRepository: SelectedRepository) {
        let managedContext = PersistentStorage.shared.persistentContainer.viewContext
        let info = RepositoryInfo(context: managedContext)
        info.repositoryName = favoriteRepository.repositoryName
        info.repositoryDescription = favoriteRepository.repositoryDescription
        info.username = favoriteRepository.username
        info.email = favoriteRepository.email
        info.image = favoriteRepository.image
        info.date = Date()
        
        try? managedContext.save()
    }
    
    func delete(repositoryName: String) {
        let managedContext = PersistentStorage.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<RepositoryInfo> = RepositoryInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "repositoryName = %@", repositoryName)
        fetchRequest.fetchLimit = 1
        let repository = (try? managedContext.fetch(fetchRequest))?.first
        if let repo = repository {
            managedContext.delete(repo)
            
            try? managedContext.save()
        }
    }
    
    func isAddedToFavorites(repositoryName: String) -> Bool {
        let managedContext = PersistentStorage.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<RepositoryInfo> = RepositoryInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "repositoryName = %@", repositoryName)
        fetchRequest.fetchLimit = 1
        
        guard let repositoriesCount = try? managedContext.count(for: fetchRequest) else {
            fatalError()
        }
        
        return repositoriesCount != 0
    }
    
    func clearAll() {
        let managedContext = PersistentStorage.shared.persistentContainer.viewContext
        let repos = managedContext.registeredObjects.filter { $0 is RepositoryInfo }
        repos.forEach(managedContext.delete)
        
        try? managedContext.save()
    }
}
