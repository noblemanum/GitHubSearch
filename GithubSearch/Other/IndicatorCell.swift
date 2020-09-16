//
//  IndicatorCell.swift
//  GithubSearch
//
//  Created by Dimon on 15.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

class IndicatorCell: UITableViewCell {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()
        indicator.startAnimating()
    }
}
