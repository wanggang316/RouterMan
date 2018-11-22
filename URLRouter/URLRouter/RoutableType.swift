//
//  RoutableType.swift
//  URLRouter
//
//  Created by gang wang on 2018/11/3.
//  Copyright © 2018 GUM. All rights reserved.
//

import UIKit


// MARK: - Controller show style

/// Contoller show style, default based top viewController.
public enum SegueKind {
    
    case push(animated: Bool)
    case present(wrap: Bool, animated: Bool)
    
    func showViewController(_ controller: UIViewController) {
        switch self {
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

// MARK: - Routable protocols

/// Routable base protocol, routable type contains class, struct or enum must inherit this protocol.
public protocol RoutableType {
    static var patterns: [String] { get }
}

/// Routable controller protocol
/// Routable UIViewController base code should implement this protocol.
public protocol RoutableControllerType: RoutableType {
    init(_ url: URLConvertible)
    var segueKind: SegueKind { get }
}

/// Storyboard controller protocol
/// UIViewController based storyboard should implement this protocol.
public protocol StoryboardControllerType {
    static var storyboardName: String { get }
    static var identifier: String { get }
}

/// Routable storyboard controller protocol, implement this method for your controller initialization.
public protocol RoutableStoryboardControllerType: RoutableType, StoryboardControllerType {
    func initViewController(_ url: URLConvertible)
    var segueKind: SegueKind { get }
}

/// Routable action protocol, you can implement this protocol custom your routable action
public protocol RoutableActionType: RoutableType {
    @discardableResult
    static func handle(_ url: URLConvertible) -> Bool
}


// MARK: - Default implements

extension RoutableControllerType {
    var segueKind: SegueKind {
        return .push(animated: true)
    }
}

extension RoutableStoryboardControllerType {
    var segueKind: SegueKind {
        return .push(animated: true)
    }
}

extension StoryboardControllerType {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static func instance() -> UIViewController {
        let storyboard = UIStoryboard(name: Self.storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Self.identifier)
        return controller
    }
}
