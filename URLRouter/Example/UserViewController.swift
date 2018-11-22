//
//  UserViewController.swift
//  URLRouter
//
//  Created by wanggang on 09/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {


    // MARK: - URLRoutable
    convenience required init(_ url: URLConvertible) {
        self.init()
        print("init parameters: \(String(describing: url.urlStringValue))")
    }
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.title = "user"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UserViewController: RoutableControllerType {
    static var patterns: [String] {
        return ["abc://page/user/\\d+"]
    }
    
//    convenience init(_ parameters: [String: Any]) {
//        self.init()
//    }
    
}
