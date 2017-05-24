//
//  FloraViewController.swift
//  Flora
//
//  Created by Florian Richter on 5/14/17.
//  Copyright © 2017 Florian Richter. All rights reserved.
//

import UIKit

class ScarfViewController: FloraViewController {
    
    @IBOutlet weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FloraBLEManager.sharedInstance.startScan()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSend(_ sender: Any) {
        //FloraBLEManager.sharedInstance.sendMessageToPeripheral(msg: "-0,0,255,0")
        //FloraBLEManager.sharedInstance.sendMessageToPeripheral(msg: "-100,0,20,0")
        //FloraBLEManager.sharedInstance.sendMessageToPeripheral(msg: "-255,0,0,2")
        let array = Array(repeating: Array(repeating: 0, count: 3), count: 21)
        
        LEDScarf.sharedInstance.setWholeArray(rgbLEDData: array)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ledViewController = segue.destination as! LEDViewController
        //hard coded for now, will be changed depending on button being pressed
        ledViewController.led = 0
    }
}
