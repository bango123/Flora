//
//  FloraViewController.swift
//  Flora
//
//  Created by Florian Richter on 5/21/17.
//  Copyright © 2017 Florian Richter. All rights reserved.
//

import UIKit

class FloraViewController: UIViewController {
    var alertController: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Subscribe to Flora Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(canStartScanning(_:)), name: NSNotification.Name(rawValue: "canStartScanning"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startScanning(_:)), name: NSNotification.Name(rawValue: "startScanning"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connectedToFlora(_:)), name: NSNotification.Name(rawValue: "connectedToFlora"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // unsubscribe to the Flora Notifications
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "canStartScanning"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "startScanning"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "connectedToFlora"), object: nil)
    }
    
    func canStartScanning(_ notification: Notification){
        FloraBLEManager.sharedInstance.startScan()
    }
    
    func startScanning(_ notification: Notification){
        DispatchQueue.main.async(execute: {[unowned self] in
            self.alertController = UIAlertController(title: nil, message: "Finding Flora", preferredStyle: .alert)
            self.present(self.alertController, animated: true, completion:nil)
        })
    }
    
    func connectedToFlora(_ notification: Notification){
        self.alertController.dismiss(animated: true, completion: nil)
    }
}
