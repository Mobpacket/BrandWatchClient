//
//  TTLCache.swift
//  BrandWatchClient
//
//  Created by Nabib El-RAHMAN on 10/26/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//


class TTLCache {
    
    class var sharedInstance: TTLCache {
        
        struct Static {
            
            static let instance = TTLCache(timeToLive: 5 * 60)
        }
        
        return Static.instance
    }
    
    var cache = [String: CacheEntry]()
    var timeToLive: Int!
    
    init(timeToLive: Int) {
        
        self.timeToLive = timeToLive
    }
    
    func put(object: AnyObject!, forKey: String!) {
        
        var entry = self.cache[forKey]
        
        if(entry == nil) {
            
            entry = CacheEntry()
            entry?.entryKey = forKey
            entry?.timeToLiveInSeconds = self.timeToLive
            entry?.lastModified = NSDate()
            entry?.object = object
        } else {
            
            entry?.lastModified = NSDate()
            entry?.object = object
        }
        
        cache[forKey] = entry
    }
    
    func get(forKey: String) -> AnyObject? {
        
        var entry = self.cache[forKey]
        
        if entry == nil {
            
            return nil
        }
        
        if entry?.isExpired() == true {
            
            self.cache.removeValueForKey(forKey)
            
            return nil
        }
        
        return entry?.object
    }
    
    func remove(forKey: String) {
        
        self.cache.removeValueForKey(forKey)
    }
}

class CacheEntry {
    
    var entryKey: String!
    var timeToLiveInSeconds: Int!
    var lastModified: NSDate!
    var object: AnyObject!
    
    func isExpired() -> Bool {
        
        var timeInterval = self.lastModified.timeIntervalSinceNow
        return timeInterval > Double(self.timeToLiveInSeconds) ? true : false
    }
}
