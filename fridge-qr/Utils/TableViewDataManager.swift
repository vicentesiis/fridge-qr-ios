//
//  TableViewDataManager.swift
//  fridge-qr
//
//  Created by Vicente Cantu Garcia on 11/20/18.
//  Copyright © 2018 Vicente Cantu Garcia. All rights reserved.
//

import UIKit

class TableViewDataManager<T> {
    
    private var page = 1
    private var delegate: PageManagerDelegate
    private var tableView: UITableView
    private var collection = Array<T>()
    
    init(tableView: UITableView,
         delegate: PageManagerDelegate, pagination: Bool) {
        
        self.page = 1
        self.delegate = delegate
        self.tableView = tableView
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        
        if pagination {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(self.add), for: .valueChanged)
//            tableView.bottomRefreshControl = UIRefreshControl()
//            tableView.bottomRefreshControl?.addTarget(self, action: #selector(self.add), for: .valueChanged)
        }
        
        load(page: 1)
    }
    
    @objc func add(){
        page += 1
        load(page: page)
    }
    
    @objc func reload(){
        page = 1
        load(page: 1)
    }
    
    private func load(page:Int = 1) {
        delegate.pageManagerDataLoad(page: page)
    }
    
    func manageData(collection:[T]){
        self.tableView.refreshControl?.endRefreshing()
//        self.tableView.bottomRefreshControl?.endRefreshing()
        if page > 1{
            self.collection.append(contentsOf: collection)
        }
        else{
            self.collection = collection
        }
    }
    
    func getCount() -> Int{
        return collection.count
    }
    
    func getObject(index: Int) -> T{
        return collection[index]
    }
    
    func removeObject(at: Int){
        let indexPath = IndexPath(row: at, section: 0)
        collection.remove(at: at)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        tableView.endUpdates()
    }
}
