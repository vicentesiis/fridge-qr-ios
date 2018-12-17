//
//  GeneratorQRViewController.swift
//  QRTest
//
//  Created by Vicente Cantu Garcia on 10/17/18.
//  Copyright © 2018 Vicente Cantu Garcia. All rights reserved.
//

import UIKit
import QRCodeGenerator

class GeneratorQRViewController: UIViewController{

    @IBOutlet weak var qrCodeView: QRCodeView!
    @IBOutlet weak var product: UIPickerView!
    @IBOutlet weak var quantity: UITextField!
    
    let products = ["Leche Canela", "Lecha Vainilla", "Platano", "Manzana"]
    var productSelected = "Leche Canela"
    
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
        print(productSelected)
        body.product.name = productSelected
        body.product.quantity = Int(quantity.text!)
        ProductJSON.createProduct(body: body, onResponse: { (response) in
            self.qrCodeView.isHidden = false
            self.qrCodeView.text = "\(response._id ?? ""), \(self.productSelected)"
            let alert = UIAlertController(title: "", message: "Código QR generado\n Producto agregado", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: {
                self.quantity.text = ""
            })
        }, onError: { (error) in
            let alert = UIAlertController(title: "Error", message: "No puede agregar un producto ya existente", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(Utils.dataToString(error!))
        }) { (_) in
            print("ERROR")
        }
    }
    
}

// MARK: - UIPicker

extension GeneratorQRViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        productSelected = products[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return products[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return products.count
    }
    
    
}

// MARK: - UITextField

extension GeneratorQRViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
