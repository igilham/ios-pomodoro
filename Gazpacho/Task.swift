//
//  Tasks.swift
//  Gazpacho
//
//  Created by Ian Gilham on 20/08/2017.
//  Copyright © 2017 Ian Gilham. All rights reserved.
//

import Foundation

class Task {
    var description: String
    var estimate: Int
    var elapsed: Int
    var complete: Bool
    
    init(description: String) {
        self.description = description
        self.estimate = 0
        self.elapsed = 0
        self.complete = false
    }
    
    init(description: String, estimate: Int) {
        self.description = description
        self.estimate = estimate
        self.elapsed = 0
        self.complete = false
    }
}

extension Task {
    public class func getMockData() -> [Task] {
        return [
            Task(description: "Make shopping list", estimate: 1),
            Task(description: "Eat all the things", estimate: 2),
            Task(description: "Raise a barn", estimate: 8),
            Task(description: "Declare war on my old enemy", estimate: 2)
        ]
    }
}
