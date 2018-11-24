//
//  CityViewController.swift
//  RouterMan
//
//  Created by gumpwang on 09/11/2016.
//  Copyright © 2016 GUMP. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
    // MARK: -
    
    required convenience init(_ url: URLConvertible) {
        self.init()
        let params = url.urlValue?.queryParameters
        let title = params?["name"]
        self.title = title
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - RoutableControllerType

extension CityViewController: RoutableControllerType {
    
    static var patterns: [String] {
        return ["abc://page/cities/\\d+\\?name=\\w+"]
    }
    
}
