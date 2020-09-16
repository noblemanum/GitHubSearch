//
//  LoadingIndicator.swift
//  GithubSearch
//
//  Created by Dimon on 08.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

class LoadingIndicator {
    
    let backgroundView: UIView
    let blackView = UIView()
    let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    init(uiView: UIView) {
        self.backgroundView = uiView
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
        loadingIndicator.center.x = backgroundView.bounds.midX
        loadingIndicator.center.y = backgroundView.bounds.midY
    }
    
    func show() {
        backgroundView.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func hide() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
}
