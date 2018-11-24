//
//  UserViewController.swift
//  RouterMan
//
//  Created by gumpwang on 09/11/2016.
//  Copyright © 2016 GUMP. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    // MARK: - Properties
    
    var userId: String?

    // MARK: - URLRoutable
    convenience required init(_ url: URLConvertible) {
        self.init()
        print("init parameters: \(String(describing: url.urlStringValue))")
        self.userId = url.urlValue?.pathComponents.last
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
        
        self.title = "user \(userId ?? "not exist")"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - RoutableControllerType

extension UserViewController: RoutableControllerType {
    
    static var patterns: [String] {
        return ["abc://page/users/\\d+"]
    }
    
}
