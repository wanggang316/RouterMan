//
//  Router.swift
//  URLRouter
//
//  Created by wanggang on 08/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

enum RouterError: Error {
    case invalidPattern
    case schemeNotRecognized
    case noMatchRoute
}

extension RouterError: CustomStringConvertible, CustomDebugStringConvertible {

    var description: String {
        switch self {
        case .invalidPattern:
            return "invalidPattern"
        case .schemeNotRecognized:
            return "schemeNotRecognized"
        case .noMatchRoute:
            return "noMatchRoute"
        }
    }
    
    var debugDescription: String {
        return description
    }
}

/// Convert other url to route url
public typealias URLRewriteHandler = (_ url: URLConvertible) -> URLConvertible

/// Router for registe a routable type and handle url
open class Router {
    
    /// This dictionary is a mapping from URL to RoutableType.
    /// The key is URL, value is the corresponding RoutableType.
    private(set) var routeMap = [String: RoutableType.Type]()

    /// Mapping a url to target url in routeMap
    /// URLRewriteHandler is convert closure
    private(set) var rewriteURLMap = [String: URLRewriteHandler]()
    
    /// Matcher for url and routable type
    public let matcher = URLMatcher()
    
    /// Default instance
    public static var `default`: Router = Router()
    
    // MARK: - Registe
    
    /// Registe single RoutableType
    open func registe(_ routableType: RoutableType.Type) {
        
        if let rewritablePatterns = routableType.rewritablePatterns {
            for (key, value) in rewritablePatterns {
                guard !key.isEmpty else {
                    fatalError(RouterError.invalidPattern.description)
                }
                rewriteURLMap[key] = value
            }
        }
        self.routeMap[routableType.pattern] = routableType
    }
    
    /// Registe multiple RoutableType
    open func registe(_ routableTypes: [RoutableType.Type]) {
        for routableType in routableTypes {
            self.registe(routableType)
        }
    }
    
    // MARK: - Handle

    open func handle(_ url: URLConvertible) throws {
        
        guard let routableType = matcher.routableType(for: url, from: routeMap, and: rewriteURLMap) else {
            throw RouterError.noMatchRoute
        }
        
        if let routableType = routableType as? RoutableControllerType.Type {
            
            if let controller = routableType.init(url) as? UIViewController {
                
                if let routableController = controller as? RoutableControllerType {
                    routableController.segueKind.showViewController(controller)
                }
            }
        } else if let routableType = routableType as? RoutableStoryboardControllerType.Type {
            
            let controller = routableType.instance()
            
            if let routableController = controller as? RoutableStoryboardControllerType {
                routableController.initViewController(url)
                
                routableController.segueKind.showViewController(controller)
            }
        } else if let routableType = routableType as? RoutableActionType.Type {
            routableType.handle(url)
        }
    }
}

