//
//  AddProductsViewController.swift
//  fridge-qr
//
//  Created by Vicente Cantu Garcia on 12/17/18.
//  Copyright © 2018 Vicente Cantu Garcia. All rights reserved.
//

import UIKit

class AddProductsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Configuración"
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
