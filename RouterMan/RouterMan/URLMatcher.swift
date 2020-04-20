//
//  URLMatcher.swift
//  RouterMan
//
//  Created by gumpwang on 2018/11/20.
//  Copyright © 2018 GUMP. All rights reserved.
//

import Foundation

open class URLMatcher {
    
    public init() { }
    
    func routableType(for url: URLConvertible,
                      lowRouteMap: [String: RoutableType.Type],
                      normalRouteMap: [String: RoutableType.Type],
                      highRouteMap: [String: RoutableType.Type]) -> RoutableType.Type? {
        return self.routableType(for: url, from: highRouteMap)
            ?? self.routableType(for: url, from: normalRouteMap)
            ?? self.routableType(for: url, from: lowRouteMap)
    }
    
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
