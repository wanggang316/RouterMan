//
//  Router.swift
//  nys
//
//  Created by wanggang on 08/11/2016.
//  Copyright © 2016 ZBJ. All rights reserved.
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


open class Router {
    
    /// This dictionary is a mapping from URL to RoutableType.
    /// The key is URL, value is the corresponding RoutableType.
    private(set) var routeMap = [String: RoutableType.Type]()

    /// Mapping a url to target url in routeMap
    /// URLRewriteHandler is convert closure
    private(set) var rewriteRouteMap = [String: URLRewriteHandler]()
    
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
                rewriteRouteMap[key] = value
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
        
        guard let routableType = routableType(for: url) else {
            throw RouterError.noMatchRoute
        }
        
        if let routableType = routableType as? RoutableControllerType.Type {
            
            if let controller = routableType.init(url) as? UIViewController {
                
                if let routableController = controller as? RoutableControllerType {
                    routableController.segueKind.showViewController(controller)
                }
            }
        } else if let routableType = routableType as? RoutableStoryboardControllerType.Type {

            let storyboard = UIStoryboard(name: routableType.storyboardName, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: routableType.identifier)
            
            if let routableController = controller as? RoutableStoryboardControllerType {
                routableController.initViewController(url)
                
                routableController.segueKind.showViewController(controller)
            }
        } else if let routableType = routableType as? RoutableActionType.Type {
            routableType.handle(url)
        }
    }
    
    // MARK: - Private Methods
    
    /// Get routable type from routeMap or rewriteRouteMap
    private func routableType(for url: URLConvertible) -> RoutableType.Type? {
        
        var routableType: RoutableType.Type?

        let result = self.routeMap.keys.filter {
            self.evaluate(forString: url.urlStringValue, withRegex: $0)
        }
        
        if result.isEmpty {
            let result = self.rewriteRouteMap.keys.filter {
                self.evaluate(forString: url.urlStringValue, withRegex: $0)
            }
            if let key = result.first {
                if let rewriteHandler = self.rewriteRouteMap[key] {
                    let newURL = rewriteHandler(url)
                    return self.routableType(for: newURL)
                }
            }
        } else {
            if let key = result.first {
                routableType = self.routeMap[key]
            }
        }
        return routableType
    }
}

// MARK: - Extensions

extension Router {
    
    /// Regular validation
    func evaluate(forString string: String, withRegex regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }
}

