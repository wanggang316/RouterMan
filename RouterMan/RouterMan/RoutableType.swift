//
//  RoutableType.swift
//  RouterMan
//
//  Created by gumpwang on 2018/11/3.
//  Copyright © 2018 GUMP. All rights reserved.
//

import UIKit

// MARK: - Controller transition style

/// Contoller transition style, default based top viewController.
public enum SegueKind {
    case push(animated: Bool)
    case present(wrap: Bool, animated: Bool)
}

// MARK: - Routable protocols

/// Routable base protocol, routable type contains class, struct or enum must inherit this protocol.
public protocol RoutableType {
    static var patterns: [String] { get }
}

public protocol ControllerType {
    var segueKind: SegueKind { get }
}

/// Routable controller protocol
/// Routable UIViewController base code should implement this protocol.
public protocol RoutableControllerType: RoutableType, ControllerType {
    init(_ url: URLConvertible)
}

/// Storyboard controller protocol
/// UIViewController based storyboard should implement this protocol.
public protocol StoryboardControllerType: ControllerType {
    static var storyboardName: String { get }
    static var identifier: String { get }
}

/// Routable storyboard controller protocol, implement this method for your controller initialization.
public protocol RoutableStoryboardControllerType: RoutableType, StoryboardControllerType {
    func initViewController(_ url: URLConvertible)
}

/// Routable action protocol, you can implement this protocol custom your routable action
public protocol RoutableActionType: RoutableType {
    @discardableResult
    static func handle(_ url: URLConvertible) -> Bool
}

// MARK: - Default implements

extension RoutableType {
    public static func shouldHandle(_ shouldHandle: @escaping (Bool) -> Void) {
        shouldHandle(true)
    }
}

extension ControllerType {
    public var segueKind: SegueKind {
        return .push(animated: true)
    }
    
    public func show(_ fromViewController: UIViewController, completion: @escaping () -> Void) {
        
        guard let controller = self as? UIViewController else { return }
        
        switch segueKind {
        case .push(let animated):
            if let delegate = self as? RoutableTypeDelegate {
                delegate.shouldShowController(controller,
                                              fromViewController: fromViewController,
                                              segueKind: self.segueKind) { shouldShow in
                    
                    guard shouldShow else { return }
                    
                    delegate.willShowController(controller,
                                                fromViewController: fromViewController,
                                                segueKind: self.segueKind)
                    fromViewController.navigationController?.pushViewController(controller, animated: animated)
                    delegate.didShownController(controller,
                                                fromViewController: fromViewController,
                                                segueKind: self.segueKind)
                }
            } else {
                fromViewController.navigationController?.pushViewController(controller, animated: animated)
            }
            completion()
        case .present(let wrap, let animated):
            
            if let delegate = self as? RoutableTypeDelegate {
                delegate.shouldShowController(controller,
                                              fromViewController: fromViewController,
                                              segueKind: self.segueKind) { shouldShow in
                    
                    guard shouldShow else { return }
                    
                    delegate.willShowController(controller,
                                                fromViewController: fromViewController,
                                                segueKind: self.segueKind)
                    
                    if wrap {
                        let navController = UINavigationController.init(rootViewController: controller)
                        fromViewController.present(navController, animated: animated) {
                            delegate.didShownController(controller,
                                                        fromViewController: fromViewController,
                                                        segueKind: self.segueKind)
                            completion()
                        }
                    } else {
                        fromViewController.present(controller, animated: animated) {
                            delegate.didShownController(controller,
                                                        fromViewController: fromViewController,
                                                        segueKind: self.segueKind)
                            completion()
                        }
                    }
                }
            } else {
                if wrap {
                    let navController = UINavigationController.init(rootViewController: controller)
                    fromViewController.present(navController, animated: animated) {
                        completion()
                    }
                } else {
                    fromViewController.present(controller, animated: animated) {
                        completion()
                    }
                }
            }
        }
    }
}

extension RoutableControllerType {
    public var segueKind: SegueKind {
        return .push(animated: true)
    }
}

extension RoutableStoryboardControllerType {
    public var segueKind: SegueKind {
        return .push(animated: true)
    }
    
    public static var identifier: String {
        return String(describing: self)
    }
    
    public static func instance() -> Self? {
        let storyboard = UIStoryboard(name: Self.storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Self.identifier) as? Self
        return controller
    }
}

extension StoryboardControllerType where Self: UIViewController {
    
    public static var identifier: String {
        return String(describing: self)
    }
    
    public static func instance() -> Self? {
        let storyboard = UIStoryboard(name: Self.storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: Self.identifier) as? Self
        return controller
    }
}

