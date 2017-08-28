//
//  Tasks.swift
//  Gazpacho
//
//  Created by Ian Gilham on 20/08/2017.
//  Copyright © 2017 Ian Gilham. All rights reserved.
//

import Foundation

class Task : NSObject, NSCoding {
    var title: String
    var estimate: Int
    var elapsed: Int
    var complete: Bool
    
    init(title: String) {
        self.title = title
        self.estimate = 0
        self.elapsed = 0
        self.complete = false
    }
    
    init(title: String, estimate: Int) {
        self.title = title
        self.estimate = estimate
        self.elapsed = 0
        self.complete = false
    }
    
    // implement NSCoding protocol
    required init?(coder aDecoder: NSCoder) {
        // Try to deserialize the "description" variable
        // error if any field is missing
        if let title = aDecoder.decodeObject(forKey: "title") as? String {
            self.title = title
        } else {
            return nil
        }
        
        if aDecoder.containsValue(forKey: "estimate") {
            self.estimate = Int(aDecoder.decodeInt32(forKey: "estimate"))
        }
        else {
            return nil
        }
        
        if aDecoder.containsValue(forKey: "elapsed") {
            self.elapsed = Int(aDecoder.decodeInt32(forKey: "elapsed"))
        }
        else {
            return nil
        }
        
        if aDecoder.containsValue(forKey: "complete") {
            self.complete = aDecoder.decodeBool(forKey: "complete")
        }
        else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        // Store the objects into the coder object
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.estimate, forKey: "estimate")
        aCoder.encode(self.elapsed, forKey: "elapsed")
        aCoder.encode(self.complete, forKey: "complete")
    }
}

extension Task {
    public class func getMockData() -> [Task] {
        return [
            Task(title: "Make shopping list", estimate: 1),
            Task(title: "Eat all the things", estimate: 2),
            Task(title: "Raise a barn", estimate: 8),
            Task(title: "Declare war on my old enemy", estimate: 2)
        ]
    }
}

// Creates an extension of the Collection type (aka an Array),
// but only if it is an array of ToDoItem objects.
extension Collection where Iterator.Element == Task {
    // Builds the persistence URL. This is a location inside
    // the "Application Support" directory for the App.
    private static func persistencePath() -> URL? {
        let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)
        
        return url?.appendingPathComponent("tasks.bin")
    }
    
    // Write the array to persistence
    func writeToPersistence() throws {
        if let url = Self.persistencePath(), let array = self as? NSArray {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            try data.write(to: url)
        } else {
            throw NSError(domain: "IanGilham.Gazpacho", code: 10, userInfo: nil)
        }
    }
    
    // Read the array from persistence
    static func readFromPersistence() throws -> [Task] {
        if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?) {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Task] {
                return array
            } else {
                throw NSError(domain: "IanGilham.Gazpacho", code: 11, userInfo: nil)
            }
        } else {
            throw NSError(domain: "IanGilham.Gazpacho", code: 12, userInfo: nil)
        }
    }
}
