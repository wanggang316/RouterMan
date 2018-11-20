//
//  RoutableType.swift
//  URLRouter
//
//  Created by gang wang on 2018/11/3.
//  Copyright © 2018 GUM. All rights reserved.
//

import UIKit

public typealias URLRewriteHandler = (_ url: URLConvertible) -> URLConvertible

// MARK: - Controller show style

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

public protocol RoutableType {
    static var pattern: String { get }
    static var rewritablePatterns: [String: URLRewriteHandler]? { get }
}

public protocol RoutableControllerType: RoutableType {
    init(_ url: URLConvertible)
    var segueKind: SegueKind { get }
}

public protocol StoryboardControllerType {
    static var storyboardName: String { get }
    static var identifier: String { get }
}

public protocol RoutableStoryboardControllerType: RoutableType, StoryboardControllerType {
    func initViewController(_ url: URLConvertible)
    var segueKind: SegueKind { get }
}

public protocol RoutableActionType: RoutableType {
    @discardableResult
    static func handle(_ url: URLConvertible) -> Bool
}

extension RoutableType {
    static var rewritablePatterns: [String: URLRewriteHandler]? { 
        return nil
    }
}

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
    static func controller() -> UIViewController {
        let storyboard = UIStoryboard(name: Self.storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Self.identifier)
        return controller
    }
}
