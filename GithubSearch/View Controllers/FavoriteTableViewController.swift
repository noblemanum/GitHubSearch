//
//  FavoriteTableViewController.swift
//  GithubSearch
//
//  Created by Dimon on 08.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit
import CoreData

class FavoriteTableViewController: UITableViewController {

    private lazy var clearAllButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAllRepositoriesButton))
    }()
    
    private let favouriteRepositoriesController = FavoriteRepositoriesController()
    private var selectedRepository: SelectedRepository?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<RepositoryInfo> = {
        let request: NSFetchRequest<RepositoryInfo> = RepositoryInfo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: PersistentStorage.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? fetchedResultsController.performFetch()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        let numberOfRepositories = sections[section].numberOfObjects
        if numberOfRepositories == 0 {
            navigationItem.rightBarButtonItem = nil
            TableViewHelper.emptyMessage(message: "Favorites is empty. Add some repositories.", viewController: self)
        } else {
            navigationItem.rightBarButtonItem = clearAllButton
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        
        return numberOfRepositories
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteRepositoryCell", for: indexPath)

        let repository = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = repository.repositoryName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let repositories = fetchedResultsController.fetchedObjects else { return }
        let repository = repositories[indexPath.row]
        selectedRepository = SelectedRepository(repositoryName: repository.repositoryName ?? "", repositoryDescription: repository.repositoryDescription ?? "No repository description", login: nil, username: repository.username ?? "No name", email: repository.email ?? "No email", image: repository.image)
        performSegue(withIdentifier: "FavoritesRepositorySegue", sender: nil)
    }
    
    @objc private func deleteAllRepositoriesButton() {
        let alert = UIAlertController(title: nil, message: "Do you really want to delete all repositories from favorites?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.favouriteRepositoriesController.clearAll()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoritesRepositorySegue" {
        if let destination = segue.destination as? RepositoryViewController {
            destination.selectedRepository = selectedRepository
            }
        }
    }
}

extension FavoriteTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let repository = fetchedResultsController.object(at: indexPath)
                guard let cell = tableView.cellForRow(at: indexPath as IndexPath) else { break }
                cell.textLabel?.text = repository.repositoryName
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
