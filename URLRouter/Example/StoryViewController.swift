//
//  StoryViewController.swift
//  URLRouter
//
//  Created by gang wang on 2018/10/28.
//  Copyright © 2018 GUM. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {

    @IBOutlet weak var storyNameLabel: UILabel!
    
    var storyName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storyNameLabel.text = storyName
    }

}

extension StoryViewController: RoutableStoryboardControllerType {
    
    static var pattern: String {
        return "abc://page/story/\\d+\\?a=\\w+"
    }
    
    static var rewritablePatterns: [String: URLRewriteHandler]? {
        let handler: URLRewriteHandler = { sourceURL in
            return "abc://page/story/234?a=newstory"
        }
        return ["http://www.iguanyu.com/story/\\d+\\?a=\\w+": handler]
    }
    
    static var storyboardName: String {
        return "Main"
    }
    
    static var identifier: String {
        return "StoryViewController"
    }
    
    func initViewController(_ url: URLConvertible) {
        print("story parameters: \(String(describing: url.urlStringValue))")
        self.storyName = url.urlValue?.queryParameters["a"]
    }
    
    
}
