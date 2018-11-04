//
//  Router.swift
//  nys
//
//  Created by wanggang on 08/11/2016.
//  Copyright © 2016 ZBJ. All rights reserved.
//

import UIKit

open class Router {
    
    /// This dictionary is a mapping from URL to controller.
    /// The key is URL, value is the corresponding controller.
    
    private(set) var routeMap = [String: RoutableType.Type]()

    private(set) var rewriteRouteMap = [String: URLRewriteHandler]()
    
    /// Default instance
    public static var `default`: Router = Router()
    
    
    // MARK: - Registe
    
    open func registe(_ routableType: RoutableType.Type) {
        print(routableType.self)
        
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
                    self.handle(newURL)
                }
            }
        } else {
            if let key = result.first {
                routableType = self.routeMap[key]
            }
        }
        
        if let routableType = routableType {
            
            if let routableType = routableType as? RoutableControllerType.Type {
                
                if let controller = routableType.init(url) as? UIViewController {
                    print(controller)
                    
                    if let routableController = controller as? RoutableControllerType {
                        switch routableController.segueKind {
                        case .push(let animated):
                            UIWindow.topViewController()?.navigationController?.pushViewController(controller, animated: animated)
                        case .present(let wrap, let animated):
                            if wrap {
                                let navController = UINavigationController.init(rootViewController: controller)
                                UIWindow.topViewController()?.present(navController, animated: animated, completion: nil)
                            } else {
                                UIWindow.topViewController()?.present(controller, animated: animated, completion: nil)
                            }
                        }
                    }
                }
            } else if let routableType = routableType as? RoutableStoryboardControllerType.Type {

                let storyboard = UIStoryboard(name: routableType.storyboardName, bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: routableType.identifier)
                
                if let routableController = controller as? RoutableStoryboardControllerType {
                    routableController.initViewController(url)
                    
                    switch routableController.segueKind {
                    case .push(let animated):
                        UIWindow.topViewController()?.navigationController?.pushViewController(controller, animated: animated)
                    case .present(let wrap, let animated):
                        if wrap {
                            let navController = UINavigationController.init(rootViewController: controller)
                            UIWindow.topViewController()?.present(navController, animated: animated, completion: nil)
                        } else {
                            UIWindow.topViewController()?.present(controller, animated: animated, completion: nil)
                        }
                    }
                }
            } else if let routableType = routableType as? RoutableActionType.Type {
                routableType.handle(url)
            } else {
    
            }
        }
    }
    
}

extension Router {
    
    /// Regular validation
    func evaluate(forString string: String, withRegex regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }
}

