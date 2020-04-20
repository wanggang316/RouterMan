//
//  URLConvertible.swift
//  RouterMan
//
//  Created by gumpwang on 09/11/2016.
//  Copyright © 2016 GUMP. All rights reserved.
//

import Foundation

public protocol URLConvertible {
    var urlValue: URL? { get }
    var urlStringValue: String { get }
}

extension String: URLConvertible {
    
    public var urlValue: URL? {
        if let url = URL(string: self) {
            return url
        }
        var set = CharacterSet()
        set.formUnion(.urlHostAllowed)
        set.formUnion(.urlPathAllowed)
        set.formUnion(.urlQueryAllowed)
        set.formUnion(.urlFragmentAllowed)
        return self.addingPercentEncoding(withAllowedCharacters: set).flatMap {
            URL(string: $0)
        }
    }
    
    public var urlStringValue: String {
        return self
    }
}

extension URL: URLConvertible {
    public var urlValue: URL? {
        return self
    }
    
    public var urlStringValue: String {
        return self.absoluteString
    }
}

extension URL {
    public var queryParameters: [String: String] {
        var parameters = [String: String]()
        let urlComponent = URLComponents(url: self, resolvingAgainstBaseURL: false)
        guard let queryItems = urlComponent?.queryItems else { return parameters }
        queryItems.forEach { parameters[$0.name] = $0.value }
        return parameters
    }
}
