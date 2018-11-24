//
//  RouteMap.swift
//  RouterMan
//
//  Created by gumpwang on 09/11/2016.
//  Copyright © 2016 GUMP. All rights reserved.
//

import UIKit

struct RouteMap {
    
    static func initialize() {
        
        Router.default.registe(UserViewController.self)
        Router.default.registe(StoryViewController.self)
        Router.default.registe(AlertActionRoute.self)
        Router.default.registe(OpenPhoneActionRoute.self)
        Router.default.registe(CityListViewController.self)
        Router.default.registe(CityViewController.self)
    }

}

class AlertActionRoute: RoutableActionType {
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

class OpenPhoneActionRoute: RoutableActionType {
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

