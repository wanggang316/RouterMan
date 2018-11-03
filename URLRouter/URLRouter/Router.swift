//
//  Router.swift
//  nys
//
//  Created by wanggang on 08/11/2016.
//  Copyright © 2016 ZBJ. All rights reserved.
//

import UIKit

public typealias URLOpenHandler = (_ url: URLConvertible) -> Bool

public typealias URLPattern = String


open class Router {
    
    /// This dictionary is a mapping from URL to controller.
    /// The key is URL, value is the corresponding controller.
//    private(set) var urlMap = [String: URLRoutable.Type]()
    
    /// This dictionary is a mapping from URL to event.
    /// The key is URL, value is the corresponding event.
    private(set) var urlOpenHandlers = [String: URLOpenHandler]()
    
    private(set) var routeMap = [String: RoutableType.Type]()

    private(set) var rewriteRouteMap = [String: URLRewriteHandler]()
    
    /// Default instance
    public static var `default`: Router = Router()
    
    
    // MARK: - add
    
    /// Registe a url with a controller, saved to `URLMap` collection.
//    open func map(_ urlPattern: URLConvertible, routable: URLRoutable.Type) {
//        self.urlMap[urlPattern.urlStringValue] = routable
//    }
    
    /// Registe a url with a event handler, saved to `URLMap` collection.
    open func map(_ urlPattern: URLConvertible, handler: @escaping URLOpenHandler) {
        self.urlOpenHandlers[urlPattern.urlStringValue] = handler
    }
    
    
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
    
    open func handle(_ url: URLConvertible, navigationController: UINavigationController) {
        
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
                    self.handle(newURL, navigationController: navigationController)
                }
            }
        } else {
            if let key = result.first {
                routableType = self.routeMap[key]
            }
        }
        
        if let routableType = routableType {
            
            let parameters = url.urlValue?.queryParameters
            
            if let routableType = routableType as? RoutableControllerType.Type {
                
                if let controller = routableType.init(parameters) as? UIViewController {
                    print(controller)
                    navigationController.pushViewController(controller, animated: true)
                }
            } else if let routableType = routableType as? RoutableStoryboardControllerType.Type {

                let storyboard = UIStoryboard(name: routableType.storyboardName, bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: routableType.identifier)
                
                if let controller = controller as? RoutableStoryboardControllerType {
                    controller.initViewController(parameters)
                }
                
                navigationController.pushViewController(controller, animated: true)
            } else if let routableType = routableType as? RoutableHandlerType.Type {
                routableType.handle(parameters)
            } else {
    
            }
        }
    }
    
    
    
    // MARK: - find
    
    /// Get controller for specified URL, if there is no matched return `nil`.
//    open func viewController(for url: URLConvertible) -> UIViewController? {
//
//        let result = self.urlMap.keys.filter {
//            self.evaluate(forString: url.urlStringValue, withRegex: $0)
//        }
//
//        if result.count > 0 {
//            let key: String = result.first!
//            let routable = self.urlMap[key]
//            return routable?.init(url: url) as? UIViewController
//        }
//        return nil
//    }
    
    open func handler(for url: URLConvertible) -> URLOpenHandler? {
        let result = self.urlOpenHandlers.keys.filter {
            self.evaluate(forString: url.urlStringValue, withRegex: $0)
        }
        
        if result.count > 0 {
            let key: String = result.first!
            let handler: URLOpenHandler = self.urlOpenHandlers[key]!
            return handler
        }
        return nil
    }
    
    // MARK: - handle the result, `UIViewController` or `URLOpenHandler`
    
    /// A util method for manual invoke event handler which contains in `URLOpenHandlers` for the URL.
    @discardableResult
    open func open(_ url: URLConvertible) -> Bool {
        if let handler = self.handler(for: url) {
            return handler(url)
        }
        return false
    }
    
    /// A quick method for simple push transition, if not matched controller, nothing to do.
//    open func push(_ url: URLConvertible, from navigationController: UINavigationController, animated: Bool = true) {
//        if let controller = self.viewController(for: url) {
//            navigationController.pushViewController(controller, animated: animated)
//        }
//    }
    
    /// Default present method
//    open func present(_ url: URLConvertible, from viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
//        self.present(url, from: viewController, wrap: true, animated: true, completion: completion)
//    }
    
    /// A quick method for simple present transition, if not matched controller, nothing to do.
//    open func present(_ url: URLConvertible, from viewController: UIViewController, wrap: Bool, animated: Bool = true, completion: (() -> Void)? = nil) {
//        if let controller = self.viewController(for: url) {
//            if wrap {
//                let navigationController = UINavigationController(rootViewController: controller)
//                viewController.present(navigationController, animated: animated, completion: completion)
//            } else {
//                viewController.present(controller, animated: animated, completion: completion)
//            }
//        }
//    }
}

extension Router {
    
    /// help
    func evaluate(forString string: String, withRegex regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }
}

