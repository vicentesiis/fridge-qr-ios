//
//  GeneratorQRViewController.swift
//  QRTest
//
//  Created by Vicente Cantu Garcia on 10/17/18.
//  Copyright © 2018 Vicente Cantu Garcia. All rights reserved.
//

import UIKit
import QRCodeGenerator

class GeneratorQRViewController: UIViewController {
    
    @IBOutlet weak var qrCodeView: QRCodeView!
    @IBOutlet weak var product: UITextField!
    @IBOutlet weak var quantity: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeView.errorCorrectionLevel = .M
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func generate(_ sender: Any) {
        view.endEditing(true)
        let body = ProductObject()
        body.product = Product()
        body.product.name = product.text!
        body.product.quantity = Int(quantity.text!)
        ProductJSON.createProduct(body: body, onResponse: { (response) in
            self.qrCodeView.isHidden = false
            self.qrCodeView.text = "\(response._id ?? ""), \(self.product.text!)"
            let alert = UIAlertController(title: "", message: "Código QR generado\n Producto agregado", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }, onError: { (error) in
            print(Utils.dataToString(error!))
        }) { (_) in
            print("ERROR")
        }
    }
    
}

extension GeneratorQRViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
