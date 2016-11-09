//
//  RouteMap.swift
//  nys
//
//  Created by wanggang on 09/11/2016.
//  Copyright © 2016 ZBJ. All rights reserved.
//

import UIKit

struct RouteMap {
    static func initialize() {
        
        URLRouter.default.map("abc://page/cities", routable: CityListViewController.self)
        URLRouter.default.map("abc://page/city/\\d+\\?name=\\w+", routable: CityViewController.self)
        URLRouter.default.map("abc://page/topic\\?id=\\d", routable: TopicViewController.self)
        URLRouter.default.map("abc://page/user/\\d+", routable: UserViewController.self)

        URLRouter.default.map("tel:[^\\s]+", handler: { (url) in
            print("------> \(url)")
            return true
        })

        URLRouter.default.map("zbj://alert?title=\\w+&message=\\w+", handler: { (url) in
            print("------> \(url)")
            return true
        })
    }
}
