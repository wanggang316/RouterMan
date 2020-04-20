//
//  Router.swift
//  RouterMan
//
//  Created by gumpwang on 08/11/2016.
//  Copyright © 2016 GUMP. All rights reserved.
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

public enum RouterLevel {
    case low
    case normal
    case high
}

/// Router for registe a routable type and handle url
open class Router {
    
    /// This dictionary is a mapping from URL to RoutableType.
    /// The key is URL, value is the corresponding RoutableType.
    private(set) var lowRouteMap = [String: RoutableType.Type]()
    private(set) var normalRouteMap = [String: RoutableType.Type]()
    private(set) var highRouteMap = [String: RoutableType.Type]()
    
    /// Matcher for url and routable type
    public let matcher = URLMatcher()
    
    open weak var delegate: RouterDelegate?
    
    /// Default instance
    public static var `default`: Router = Router()
    
    // MARK: - Registe
    
    /// Registe single RoutableType
    open func registe(_ routableType: RoutableType.Type, level: RouterLevel = .normal) {
        for pattern in routableType.patterns {
            guard !pattern.isEmpty else {
                fatalError(RouterError.invalidPattern.description)
            }
            switch level {
            case .low:
                self.lowRouteMap[pattern] = routableType
            case .normal:
                self.normalRouteMap[pattern] = routableType
            case .high:
                self.highRouteMap[pattern] = routableType
            }
        }
    }
    
    /// Registe multiple RoutableType
    open func registe(_ routableTypes: [RoutableType.Type], level: RouterLevel = .normal) {
        for routableType in routableTypes {
            self.registe(routableType)
        }
    }
    
    // MARK: - Handle
    
    open func handle(_ url: URLConvertible, configuration: ((RoutableType) -> Void)? = nil) throws {
        
        guard let routableType = matcher.routableType(for: url,
                                                      lowRouteMap: lowRouteMap,
                                                      normalRouteMap: normalRouteMap,
                                                      highRouteMap: highRouteMap) else {
                                                        throw RouterError.noMatchRoute
        }
        
        routableType.shouldHandle { result in
            guard result else { return }
            
            if let routableType = routableType as? RoutableControllerType.Type {
                
                guard let topViewController = UIWindow.topViewController() else { return }
                
                if let controller = routableType.init(url) as? UIViewController {
                    
                    if let routableController = controller as? RoutableControllerType {
                        configuration?(routableController)
                        
                        let segueKind = routableController.segueKind
                        self.showViewController(controller, fromViewController: topViewController, segueKind: segueKind)
                    }
                }
            } else if let routableType = routableType as? RoutableStoryboardControllerType.Type {
                
                guard let topViewController = UIWindow.topViewController() else { return }
                guard let routableController = routableType.instance() else { return }
                
                routableController.initViewController(url)
                if let controller = routableController as? UIViewController {
                    configuration?(routableController)
                    
                    let segueKind = routableController.segueKind
                    self.showViewController(controller, fromViewController: topViewController, segueKind: segueKind)
                }
                
            } else if let routableType = routableType as? RoutableActionType.Type {
                routableType.handle(url)
            }
        }
    }
    
    /// Show
    private func showViewController(_ controller: UIViewController,
                                    fromViewController: UIViewController,
                                    segueKind: SegueKind) {
        
        let showColsure: (_ controller: UIViewController,
                          _ from: UIViewController,
                          _ segueKind: SegueKind,
                          _ completion: @escaping () -> Void) -> Void = { controller, from, segueKind, completion in
            if let routableController = controller as? ControllerType {
                routableController.show(fromViewController) {
                    completion()
                }
            }
        }
        
        if self.delegate != nil {
            self.delegate?.shouldShowController(controller,
                                                fromViewController: fromViewController,
                                                segueKind: segueKind) { shouldShow in
                if shouldShow != false {
                    self.delegate?.willShowController(controller,
                                                      fromViewController: fromViewController,
                                                      segueKind: segueKind)
                    
                    showColsure(controller, fromViewController, segueKind) {
                        self.delegate?.didShownController(controller,
                                                          fromViewController: fromViewController,
                                                          segueKind: segueKind)
                    }
                }
            }
        } else {
            showColsure(controller, fromViewController, segueKind) { }
        }
    }
}
