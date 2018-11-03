//
//  CityListViewController.swift
//  URLRouter
//
//  Created by wanggang on 09/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let items = [
        "abc://page/city/1?name=boston",
        "abc://page/city/2?name=seattle",
        "abc://page/city/3?name=chicago",
        "abc://page/city/4?name=berkeley",
        "abc://page/city/5?name=miami",
        "abc://page/city/6?name=london",
        "abc://page/city/7?name=oxford"
    ]
    
    // MARK: - URLRoutable
    convenience required init?(url: URLConvertible) {
        self.init()
        print(url)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "cities"
        self.view.backgroundColor = UIColor.groupTableViewBackground
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
        
//        URLRouter.default.push(item, from: self.navigationController!)
    }

}
