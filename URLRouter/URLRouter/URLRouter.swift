//
//  Route.swift
//  nys
//
//  Created by wanggang on 08/11/2016.
//  Copyright © 2016 ZBJ. All rights reserved.
//

import UIKit

public protocol Routable: AnyObject {
    static var pattern: String { get }
}

public protocol RoutableStoryboardControllerType: Routable {
    static var storyboardName: String { get }
    static var identifier: String { get }
    func steupController(_ parameters: [String: Any])
}

public protocol RoutableControllerType: Routable {
    init(_ parameters: [String: Any])
    func steupController(_ parameters: [String: Any])
}

public protocol RoutableType: Routable {
    var handler: (_ parameters: [String: Any]) -> Bool { get }
}

public protocol URLRoutable {
    init?(url: URLConvertible)
}


public typealias URLOpenHandler = (_ url: URLConvertible) -> Bool
public typealias ControllerHandler = (_ url: URLConvertible) -> Bool

public typealias URLPattern = String
public typealias ViewControllerFactory = (_ url: URLConvertible, _ values: [String: Any], _ context: Any?) -> UIViewController?
public typealias URLOpenHandlerFactory = (_ url: URLConvertible, _ values: [String: Any], _ context: Any?) -> Bool


open class URLRouter {
    
    /// This dictionary is a mapping from URL to controller.
    /// The key is URL, value is the corresponding controller.
    private(set) var urlMap = [String: URLRoutable.Type]()
    
    /// This dictionary is a mapping from URL to event.
    /// The key is URL, value is the corresponding event.
    private(set) var urlOpenHandlers = [String: URLOpenHandler]()
    
    private(set) var routeMap = [String: Routable.Type]()

    
    /// Default instance
    public static var `default`: URLRouter = URLRouter()
    
    
    
    
    // MARK: - add
    
    /// Registe a url with a controller, saved to `URLMap` collection.
    open func map(_ urlPattern: URLConvertible, routable: URLRoutable.Type) {
        self.urlMap[urlPattern.urlStringValue] = routable
    }
    
    /// Registe a url with a event handler, saved to `URLMap` collection.
    open func map(_ urlPattern: URLConvertible, handler: @escaping URLOpenHandler) {
        self.urlOpenHandlers[urlPattern.urlStringValue] = handler
    }
    
    
    open func registe(_ routableType: Routable.Type) {
        print(routableType.self)
        
        self.routeMap[routableType.pattern] = routableType
    }
    
    open func registe(_ routableTypes: [Routable.Type]) {
        for routableType in routableTypes {
            self.registe(routableType)
        }
    }
    
    open func handle(_ url: URLConvertible) {
        let result = self.routeMap.keys.filter {
            self.evaluate(forString: url.urlStringValue, withRegex: $0)
        }
        if let key = result.first {
            let routableType = self.routeMap[key]
            
            if routableType is RoutableControllerType.Type {
                let controller = (routableType as? RoutableControllerType.Type)?.init(["foo": "bar"])
                print(controller)
            } else if routableType is RoutableStoryboardControllerType.Type {
                if let routableType = routableType as? RoutableStoryboardControllerType.Type {
                    let storyboard = UIStoryboard(name: routableType.storyboardName, bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: routableType.identifier)
                    print(controller)
                }
            } else if routableType is RoutableType.Type {
    
            } else {
    
            }
        }
    }
    
    
    
    // MARK: - find
    
    /// Get controller for specified URL, if there is no matched return `nil`.
    open func viewController(for url: URLConvertible) -> UIViewController? {
        
        let result = self.urlMap.keys.filter {
            self.evaluate(forString: url.urlStringValue, withRegex: $0)
        }
        
        if result.count > 0 {
            let key: String = result.first!
            let routable = self.urlMap[key]
            return routable?.init(url: url) as? UIViewController
        }
        return nil
    }
    
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
    open func push(_ url: URLConvertible, from navigationController: UINavigationController, animated: Bool = true) {
        if let controller = self.viewController(for: url) {
            navigationController.pushViewController(controller, animated: animated)
        }
    }
    
    /// Default present method
    open func present(_ url: URLConvertible, from viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.present(url, from: viewController, wrap: true, animated: true, completion: completion)
    }
    
    /// A quick method for simple present transition, if not matched controller, nothing to do.
    open func present(_ url: URLConvertible, from viewController: UIViewController, wrap: Bool, animated: Bool = true, completion: (() -> Void)? = nil) {
        if let controller = self.viewController(for: url) {
            if wrap {
                let navigationController = UINavigationController(rootViewController: controller)
                viewController.present(navigationController, animated: animated, completion: completion)
            } else {
                viewController.present(controller, animated: animated, completion: completion)
            }
        }
    }
}

extension URLRouter {
    
    /// help
    func evaluate(forString string: String, withRegex regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }
}

