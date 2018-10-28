//
//  StoryViewController.swift
//  URLRouter
//
//  Created by gang wang on 2018/10/28.
//  Copyright © 2018 GUM. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StoryViewController: RoutableStoryboardControllerType {
    static var pattern: String {
        return "abc://page/story/\\d+\\?a=\\w+"
    }
    
    static var storyboardName: String {
        return "Main"
    }
    
    static var identifier: String {
        return "StoryViewController"
    }
    
    func steupController(_ parameters: [String : Any]) {
        print("story parameters: \(parameters)")
    }
    
    
}
