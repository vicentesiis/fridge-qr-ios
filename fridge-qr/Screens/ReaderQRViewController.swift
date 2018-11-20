//
//  ReaderQRViewController.swift
//  QRTest
//
//  Created by Vicente Cantu Garcia on 10/17/18.
//  Copyright © 2018 Vicente Cantu Garcia. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class ReaderQRViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
//    @IBOutlet weak var optionSegmented: UISegmentedControl!
    
    var value = ""
    var enter = true
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.preferredStatusBarStyle = .lightContent
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - Actions
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    func scanInModalAction() {
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        present(readerVC, animated: true, completion: nil)
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "confirm", sender: nil)
        })
        value = result.value.folding(options: .diacriticInsensitive, locale: .current)
        
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(value)
        if let vcConfirm = segue.destination as? ConfirmViewController {
            if enter {
                vcConfirm.viewTitle = "Confirmar ingreso"
                vcConfirm.result = value
            } else {
                vcConfirm.viewTitle = "Confirmar salida"
                vcConfirm.result = value
            }
        }
    }
    
    @IBAction func enterMaterial(_ sender: Any) {
        scanInModalAction()
        enter = true
    }
    
    @IBAction func extractMaterial(_ sender: Any) {
        scanInModalAction()
        enter = false
    }
    

}
