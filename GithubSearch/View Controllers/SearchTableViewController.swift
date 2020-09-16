//
//  SearchTableViewController.swift
//  GithubSearch
//
//  Created by Dimon on 05.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private var repositoriesController = RepositoriesController()
    private var repositories = [Repository]()
    private let throttler = Throttler(delay: 0.5)
    private var pageNumber = 1
    private var isDataLoding = false
    private var selectedRepository: SelectedRepository?
    private var repositoriesTotalCount = 0
    private let segueIdentifier = "SearchRepositorySegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Repositories"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        setEmptyMessage()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if repositories.count == repositoriesTotalCount {
            return repositories.count
        } else if repositories.count != 0 {
            return repositories.count + 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard indexPath.row < repositories.count else {
            return tableView.dequeueReusableCell(withIdentifier: "indicatorCell", for: indexPath)
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath)
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository.repositoryFullName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !isDataLoding, indexPath.row == repositories.count else {
            return
        }
        
        pageNumber += 1
        fetchMatchingRepositories()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard repositories.indices.contains(indexPath.row) else {
            return
        }
        let repository = repositories[indexPath.row]
        selectedRepository = SelectedRepository(repositoryName: repository.repositoryFullName,
                                                repositoryDescription: repository.description,
                                                login: repository.owner.login,
                                                username: nil,
                                                email: nil,
                                                image: nil)
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func fetchMatchingRepositories() {
        
        isDataLoding = true
        let searchTerm = searchController.searchBar.text ?? ""
        
        guard !searchTerm.isEmpty else {
            return
        }
        
        let query = [
            "q": searchTerm,
            "page": String(pageNumber),
            "per_page": "20"
        ]
        
        repositoriesController.fetchRepositories(matching: query) { (repositories) in
            guard let unwrappedRepositories = repositories,
                let requestString = self.searchController.searchBar.text else { return }
            
            if requestString == searchTerm,
                unwrappedRepositories.items.count != 0 {
                self.repositories.append(contentsOf: unwrappedRepositories.items)
                self.repositoriesTotalCount = unwrappedRepositories.totalCount
                self.tableView.reloadData()
            } else if unwrappedRepositories.items.count == 0 {
                TableViewHelper.emptyMessage(message: "No repositories with this name.", viewController: self)
            }
            
            self.isDataLoding = false
        }
    }
    
    func setEmptyMessage() {
        TableViewHelper.emptyMessage(message: "Write something in the search bar to search for repositories.", viewController: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier,
            let destination = segue.destination as? RepositoryViewController,
            let repository = selectedRepository {
            destination.selectedRepository = repository
        }
    }
}

// MARK: - Extensions

extension SearchTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pageNumber = 1
        repositories = []
        isDataLoding = false
        tableView.reloadData()
        tableView.backgroundView = nil
        
        if searchText != "" {
            TableViewHelper.loadingIndicator(viewController: self)
        } else {
            setEmptyMessage()
        }
        
        throttler.add {
            self.fetchMatchingRepositories()
            self.tableView.separatorStyle = .singleLine
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        pageNumber = 1
        repositories = []
        tableView.reloadData()
        setEmptyMessage()
    }
}
