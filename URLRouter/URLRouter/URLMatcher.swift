//
//  URLMatcher.swift
//  URLRouter
//
//  Created by gang wang on 2018/11/20.
//  Copyright © 2018 GUM. All rights reserved.
//

import Foundation

open class URLMatcher {
    
    public init() { }
    
    /// Get routable type from routeMap or rewriteRouteMap
    func routableType(for url: URLConvertible,
                              from routeMap: [String: RoutableType.Type],
                              and rewriteURLMap: [String: URLRewriteHandler]) -> RoutableType.Type? {
        
        var routableType: RoutableType.Type?
        
        let result = routeMap.keys.filter {
            URLMatcher.evaluate(url.urlStringValue, withRegex: $0)
        }
        
        if result.isEmpty {
            let result = rewriteURLMap.keys.filter {
                URLMatcher.evaluate(url.urlStringValue, withRegex: $0)
            }
            if let key = result.first {
                if let rewriteHandler = rewriteURLMap[key] {
                    let newURL = rewriteHandler(url)
                    return self.routableType(for: newURL, from: routeMap, and: rewriteURLMap)
                }
            }
        } else {
            if let key = result.first {
                routableType = routeMap[key]
            }
        }
        return routableType
    }
    
    /// Regular validation
    static func evaluate(_ string: String, withRegex regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }
}

