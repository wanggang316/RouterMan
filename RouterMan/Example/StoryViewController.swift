//
//  StoryViewController.swift
//  RouterMan
//
//  Created by gumpwang on 2018/10/28.
//  Copyright © 2018 GUMP. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {

    @IBOutlet weak var storyIdLabel: UILabel!
    @IBOutlet weak var storyNameLabel: UILabel!
    
    var storyId: String?
    var storyName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.storyIdLabel.text = "Id: \(storyId ?? "None")"
        self.storyNameLabel.text = "Name: \(storyName ?? "None")"
    }

}

// MARK: - RoutableControllerType

extension StoryViewController: RoutableStoryboardControllerType {
    
    static var patterns: [String] {
        return ["abc://page/stories/\\d+\\?name=\\S+",
                "http://www.xxx.com/stories/\\d+\\?name=\\w+"]
    }
    
    static var storyboardName: String {
        return "Main"
    }
    
    static var identifier: String {
        return "StoryViewController"
    }
    
    func initViewController(_ url: URLConvertible) {
        print("story parameters: \(String(describing: url.urlStringValue))")
        self.storyId = url.urlValue?.pathComponents.last
        self.storyName = url.urlValue?.queryParameters["name"]
    }
    
}
