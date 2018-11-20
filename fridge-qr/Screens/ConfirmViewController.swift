//
//  ConfirmViewController.swift
//  QRTest
//
//  Created by Vicente Cantu Garcia on 10/18/18.
//  Copyright © 2018 Vicente Cantu Garcia. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var confirmTitle: UILabel!
    @IBOutlet var product: UILabel!
    
    @IBOutlet weak var quantity: UITextField!
    
    @IBOutlet weak var stepperQuantity: UIStepper!
    
    @IBOutlet weak var totallySegmented: UISegmentedControl!
    
    // MARK: - variables
    
    var viewTitle: String?
    var result: String?
    var quantityValue: Double = 0.0
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmTitle.text = viewTitle
        if let resultArray = result?.components(separatedBy: ",") {
            product.text = resultArray[1]
            ProductJSON.getProduct(id: resultArray[0], onResponse: { (response) in
                let quantity = response.quantity
                self.id = response._id
                self.quantity.text = String(quantity!)
                let temporalQuantity = Double(quantity ?? 0)
                self.stepperQuantity.value = temporalQuantity
                self.stepperQuantity.maximumValue = temporalQuantity
            }, onError: { (error) in
                print(Utils.dataToString(error!))
            }) { (_) in
                print("ERROR")
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func textFieldTextChanged(_ sender: UITextField) {
        
        if Double(sender.text ?? "0") ?? 0.0 > stepperQuantity.maximumValue {
            stepperQuantity.value = stepperQuantity.maximumValue
            quantity.text = String(Int(stepperQuantity.maximumValue))
            totallySegmented.selectedSegmentIndex = 0
        }
        if sender.text == "" {
            quantity.text = "0"
        }
    }
    
    @IBAction func buttonConfirmPressed(_ sender: Any) {
        let newProduct = ProductObject()
        newProduct.product = Product()
        newProduct.product._id = id
        newProduct.product.name = product.text
        newProduct.product.quantity = Int(quantity.text ?? "0")
        ProductJSON.putProducts(body: newProduct, onResponse: { (response) in
            print(response)
        }, onError: { (error) in
            print(Utils.dataToString(error!))
        }) { (_) in
            print("ERROR")
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func stepperPro(_ sender: UIStepper) {
        quantity.text = Int(sender.value).description
        if Double(quantity.text!) != stepperQuantity.maximumValue {
            totallySegmented.selectedSegmentIndex = 1
        } else {
            totallySegmented.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func segmentedButtonPressed(_ sender: Any) {
        if totallySegmented.selectedSegmentIndex == 0 {
            stepperQuantity.value = stepperQuantity.maximumValue
            quantity.text = String(Int(stepperQuantity.maximumValue))
        } else {
            if Double(quantity.text ?? "0") == stepperQuantity.maximumValue {
                if stepperQuantity.maximumValue > 0 && stepperQuantity.value + 1 < stepperQuantity.maximumValue {
                    quantity.text = String(Int((stepperQuantity.value + 1)))
                } else {
                    quantity.text = String(Int((stepperQuantity.value - 1)))
                }
            }
        }
    }
}
