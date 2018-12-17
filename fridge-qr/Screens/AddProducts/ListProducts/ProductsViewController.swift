//
//  ProductsViewController.swift
//  fridge-qr
//
//  Created by Vicente Cantu Garcia on 11/20/18.
//  Copyright © 2018 Vicente Cantu Garcia. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PageManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataManager: TableViewDataManager<Product>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = TableViewDataManager(tableView: tableView, delegate: self, pagination: false)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        let product = dataManager.getObject(index: indexPath.row)
        cell.textLabel?.text = product.name
        cell.detailTextLabel?.text = String(product.quantity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func pageManagerDataLoad(page: Int) {
        ProductJSON.getProducts(onResponse: { (response) in
            self.dataManager.manageData(collection: response)
            self.tableView.reloadData()
        }, onError: { (error) in
            print(Utils.dataToString(error!))
        }, notConnection: { (_) in
            print("ERROR")
        })
    }

}
