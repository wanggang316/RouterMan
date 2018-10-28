//
//  ViewController.swift
//  URLRouter
//
//  Created by wanggang on 09/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let items = [
        "abc://page/cities",
        "abc://page/city/123?name=beijing",
        "abc://page/user/124",
        "tel:12345678",
        "abc://alert?title=title&message=messsage"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.items[indexPath.row]

        URLRouter.default.handle(item)
//        let hasHander = URLRouter.default.open(item)
//        if !hasHander {
//            URLRouter.default.push(item, from: self.navigationController!)
//        }
        
    }

}

