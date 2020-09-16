//
//  TableViewHelper.swift
//  GithubSearch
//
//  Created by Dimon on 09.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation
import UIKit

class TableViewHelper {

    class func emptyMessage(message: String, viewController: UITableViewController) {
        let rectForLabel = CGRect(x: 64, y: 0, width: viewController.tableView.bounds.width - 128, height: viewController.tableView.bounds.height)
        let rectForBackgroundView = CGRect(x: 0, y: 0, width: viewController.tableView.bounds.width, height: viewController.tableView.bounds.height)
        let messageLabel = UILabel(frame: rectForLabel)
        let backgroundView = UIView(frame: rectForBackgroundView)
        messageLabel.text = message
        messageLabel.textColor = .systemGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 17)
        backgroundView.addSubview(messageLabel)

        viewController.tableView.backgroundView = backgroundView
        viewController.tableView.separatorStyle = .none
    }
    
    class func loadingIndicator(viewController: UITableViewController) {
        let rectForBackgroundView = CGRect(x: 0, y: 0, width: viewController.tableView.bounds.size.width, height: viewController.tableView.bounds.size.height)
        let backgroundView = UIView(frame: rectForBackgroundView)
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        indicator.center.x = backgroundView.bounds.midX
        indicator.center.y = backgroundView.bounds.midY
        indicator.style = .large
        indicator.color = .systemGray
        backgroundView.addSubview(indicator)
        
        viewController.tableView.backgroundView = backgroundView
        viewController.tableView.separatorStyle = .none
        indicator.startAnimating()
    }
}
