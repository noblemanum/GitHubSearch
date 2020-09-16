//
//  RepositoryViewController.swift
//  GithubSearch
//
//  Created by Dimon on 06.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit
import CoreData

class RepositoryViewController: UIViewController {
    
    var selectedRepository: SelectedRepository?
    
    private var observation: NSObjectProtocol?
    private let favouriteRepositoriesController = FavoriteRepositoriesController()
    private let userController = UserController()
    private var isRepositoryAddedToFavorites = false
    private var repositoryName = ""
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var separator: UIView!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var addToFavoriteButton: UIBarButtonItem!
    
    deinit {
        observation.map(NotificationCenter.default.removeObserver)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let repository = selectedRepository,
            let repositoryName = selectedRepository?.repositoryName else {
            return
        }
        
        self.repositoryName = repositoryName
        
        let context = PersistentStorage.shared.persistentContainer.viewContext
        observation = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave, object: context, queue: nil) {
            [weak self] _ in

            let fetchRequest: NSFetchRequest<RepositoryInfo> = RepositoryInfo.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "repositoryName == %@", repositoryName)
            let repo = (try? context.fetch(fetchRequest))?.first

            self?.isRepositoryAddedToFavorites = repo != nil
            self?.changeAddToFavoriteButtonColor()
        }

        if let userLogin = repository.login {
            
            isRepositoryAddedToFavorites = favouriteRepositoriesController.isAddedToFavorites(repositoryName: repository.repositoryName ?? "")
            changeAddToFavoriteButtonColor()
            
            let loadingIndicator = LoadingIndicator(uiView: userImage)
            loadingIndicator.show()
            addToFavoriteButton.isEnabled = false
            
            navigationItem.title = repository.repositoryName
            descriptionLabel.text = repository.repositoryDescription ?? "No description"
            
            userController.fetchUser(with: userLogin) { (user) in
                if let unwrappedUser = user {
                    self.fullNameLabel.text = unwrappedUser.name ?? "No name"
                    self.emailLabel.text = unwrappedUser.email ?? "No email"
                    
                    let task = URLSession.shared.dataTask(with: unwrappedUser.avatarURL) { (data, response, error) in
                        guard let data = data,
                            let image = UIImage(data: data) else { return }
                            DispatchQueue.main.async {
                                self.userImage.image = image
                                loadingIndicator.hide()
                                self.userImage.backgroundColor = nil
                                self.addToFavoriteButton.isEnabled = true
                            }
                        }
                    task.resume()
                }
            }
        } else {
            isRepositoryAddedToFavorites = favouriteRepositoriesController.isAddedToFavorites(repositoryName: repositoryName)
            changeAddToFavoriteButtonColor()
            
            navigationItem.title = repository.repositoryName
            descriptionLabel.text = repository.repositoryDescription
            fullNameLabel.text = repository.username
            emailLabel.text = repository.email
            if let image = repository.image {
                userImage.image = UIImage(data: image)
                userImage.backgroundColor = nil
            }
        }
    }
    
    @IBAction private func addToFavoriteTapped(_ sender: UIBarButtonItem) {
        if !favouriteRepositoriesController.isAddedToFavorites(repositoryName: repositoryName) {
            isRepositoryAddedToFavorites = true
            favouriteRepositoriesController.save(favoriteRepository: SelectedRepository(
                repositoryName: navigationItem.title,
                repositoryDescription: descriptionLabel.text,
                login: nil,
                username: fullNameLabel.text,
                email: emailLabel.text,
                image: userImage?.image?.pngData()))
        } else {
            isRepositoryAddedToFavorites = false
            favouriteRepositoriesController.delete(repositoryName: repositoryName)
        }
        changeAddToFavoriteButtonColor()
    }
    
    private func changeAddToFavoriteButtonColor() {
        if isRepositoryAddedToFavorites == true {
            addToFavoriteButton.tintColor = .systemBlue
        } else {
            addToFavoriteButton.tintColor = .systemGray
        }
    }
}

