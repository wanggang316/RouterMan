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
                      from routeMap: [String: RoutableType.Type]) -> RoutableType.Type? {
        
        var routableType: RoutableType.Type?
        
        let result = routeMap.keys.filter {
            URLMatcher.evaluate(url.urlStringValue, withRegex: $0)
        }
        
        if !result.isEmpty {
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

