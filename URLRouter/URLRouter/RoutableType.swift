//
//  RoutableType.swift
//  URLRouter
//
//  Created by gang wang on 2018/11/3.
//  Copyright © 2018 GUM. All rights reserved.
//

import Foundation

public typealias URLRewriteHandler = (_ url: URLConvertible) -> URLConvertible


public protocol RoutableType {
    static var pattern: String { get }
    static var rewritablePatterns: [String: URLRewriteHandler]? { get }
}

public protocol RoutableControllerType: RoutableType {
    init(_ parameters: [String: Any]?)
}

public protocol RoutableStoryboardControllerType: RoutableType {
    static var storyboardName: String { get }
    static var identifier: String { get }
    func initViewController(_ parameters: [String: Any]?)
}

public protocol RoutableHandlerType: RoutableType {
    @discardableResult
    static func handle(_ parameters: [String: Any]?) -> Bool
}

extension RoutableType {
    static var rewritablePatterns: [String: URLRewriteHandler]? { 
        return nil
    }
}
