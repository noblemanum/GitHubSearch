//
//  Throttler.swift
//  GithubSearch
//
//  Created by Dimon on 05.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation

class Throttler {
    
    private var workItem: DispatchWorkItem = DispatchWorkItem {}
    private let queue: DispatchQueue
    private let delay: TimeInterval

    init(delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.delay = delay
        self.queue = queue
    }

    func add(force: Bool = false, _ block: @escaping () -> Void) {
        workItem.cancel()
        workItem = DispatchWorkItem(block: block)
        
        let delay = force ? .zero : self.delay
        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}
