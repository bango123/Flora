//
//  ViewController.swift
//  Flora
//
//  Created by Florian Richter on 5/14/17.
//  Copyright © 2017 Florian Richter. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var connectionStateLabel: UILabel!
    
    var alertController: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FloraBLEManager.sharedInstance.startScan()
        
        // Subscribe to Flora Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(lookForFlora(_:)), name: NSNotification.Name(rawValue: "canStartScanning"), object: nil)
    }
    
    func lookForFlora(_ notification: Notification){
        FloraBLEManager.sharedInstance.startScan()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSend(_ sender: Any) {
        FloraBLEManager.sharedInstance.sendMessageToPeripheral(msg: "-0,0,255,0")
    }
    
}
