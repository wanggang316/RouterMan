//
//  Router.swift
//  nys
//
//  Created by wanggang on 08/11/2016.
//  Copyright © 2016 ZBJ. All rights reserved.
//

import UIKit

open class Router {
    
    private(set) var routeMap = [String: RoutableType.Type]()

    private(set) var rewriteRouteMap = [String: URLRewriteHandler]()
    
    /// Default instance
    public static var `default`: Router = Router()
    
    // MARK: - Registe
    
    open func registe(_ routableType: RoutableType.Type) {
        
        if let rewritablePatterns = routableType.rewritablePatterns {
            for (key, value) in rewritablePatterns {
                rewriteRouteMap[key] = value
            }
        }
        self.routeMap[routableType.pattern] = routableType
    }
    
    open func registe(_ routableTypes: [RoutableType.Type]) {
        for routableType in routableTypes {
            self.registe(routableType)
        }
    }
    
    // MARK: - Handle

    open func handle(_ url: URLConvertible) {
        
        guard let routableType = routableType(for: url) else {
            print("routableType not found")
            return
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
        } else {

        }
    }
    

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


extension Router {
    
    /// Regular validation
    func evaluate(forString string: String, withRegex regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }
}

