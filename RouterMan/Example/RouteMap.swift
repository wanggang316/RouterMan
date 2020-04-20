//
//  RouteMap.swift
//  RouterMan
//
//  Created by gumpwang on 09/11/2016.
//  Copyright © 2016 GUMP. All rights reserved.
//

import UIKit

class RouteMap {
    
    static let instance: RouteMap = RouteMap()
    
    init() {
        Router.default.delegate = self
    }
    
    func registe() {
        Router.default.registe(UserViewController.self)
        Router.default.registe(StoryViewController.self)
        Router.default.registe(AlertActionRouter.self)
        Router.default.registe(OpenPhoneActionRouter.self)
        Router.default.registe(CityListViewController.self)
        Router.default.registe(CityViewController.self)
    }
}

// MARK: - Router delegate

extension RouteMap: RouterDelegate {
    
    func willShowController(_ controller: UIViewController, fromViewController: UIViewController, segueKind: SegueKind) {
        print("Router willShowController")

        switch segueKind {
        case .push(_):
            controller.hidesBottomBarWhenPushed = true
            fromViewController.navigationItem.backBarButtonItem = .init(title: nil, style: .plain, target: nil, action: nil)
        default: break
        }
    }
    
    func didShownController(_ controller: UIViewController, fromViewController: UIViewController, segueKind: SegueKind) {
        print("Router didShownController")
    }
}

// MARK: - Custom Routable Actions

class AlertActionRouter: RoutableActionType {
    static func handle(_ url: URLConvertible) -> Bool {
        print("parameters \(String(describing: url.urlStringValue))")
        let title = url.urlValue?.queryParameters["title"]
        let message = url.urlValue?.queryParameters["message"]

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))

        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)

        return true
    }
    
    static var patterns: [String] {
        return ["abc://alert\\?title=\\w+&message=\\w+"]
    }
}

class OpenPhoneActionRouter: RoutableActionType {
    static func handle(_ url: URLConvertible) -> Bool {
        if let url = url.urlValue {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return true
        }
        return false
    }
    
    static var patterns: [String] {
        return ["tel:[^\\s]+"]
    }
}

