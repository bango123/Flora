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
        LEDScarf.sharedInstance.refreshArray()
        self.alertController.dismiss(animated: true, completion: nil)
    }
}


class FloraNavigationController: UINavigationController {
    
    //This function is ran when going from LEDViewController to ScarfViewController!
    override func popViewController(animated: Bool) -> UIViewController? {
        //DLog("Popping View Controller")
        let ledViewController = topViewController as! LEDViewController
        let currentLED = ledViewController.led!
        
        let scarfViewController = viewControllers[0] as! ScarfViewController
        
        //Once again, I need to learn how to code better...
        switch currentLED {
        case 0:
            scarfViewController.ledButton0.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[0])
        case 1:
            scarfViewController.ledButton1.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[1])
        case 2:
            scarfViewController.ledButton2.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[2])
        case 3:
            scarfViewController.ledButton3.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[3])
        case 4:
            scarfViewController.ledButton4.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[4])
        case 5:
            scarfViewController.ledButton5.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[5])
        case 6:
            scarfViewController.ledButton6.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[6])
        case 7:
            scarfViewController.ledButton7.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[7])
        case 8:
            scarfViewController.ledButton8.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[8])
        case 9:
            scarfViewController.ledButton9.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[9])
        case 10:
            scarfViewController.ledButton10.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[10])
        case 11:
            scarfViewController.ledButton11.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[11])
        case 12:
            scarfViewController.ledButton12.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[12])
        case 13:
            scarfViewController.ledButton13.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[13])
        case 14:
            scarfViewController.ledButton14.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[14])
        case 15:
            scarfViewController.ledButton15.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[15])
        case 16:
            scarfViewController.ledButton16.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[16])
        case 17:
            scarfViewController.ledButton17.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[17])
        case 18:
            scarfViewController.ledButton18.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[18])
        case 19:
            scarfViewController.ledButton19.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[19])
        case 20:
            scarfViewController.ledButton20.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[20])
        default: break
        }
        
        return super.popViewController(animated: animated)
    }
}
