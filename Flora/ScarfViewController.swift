//
//  FloraViewController.swift
//  Flora
//
//  Created by Florian Richter on 5/14/17.
//  Copyright © 2017 Florian Richter. All rights reserved.
//

import UIKit

class ScarfViewController: FloraViewController {
    
    @IBOutlet weak var ledButton0: MyButton!
    @IBOutlet weak var ledButton1: MyButton!
    @IBOutlet weak var ledButton2: MyButton!
    @IBOutlet weak var ledButton3: MyButton!
    @IBOutlet weak var ledButton4: MyButton!
    @IBOutlet weak var ledButton5: MyButton!
    @IBOutlet weak var ledButton6: MyButton!
    @IBOutlet weak var ledButton7: MyButton!
    @IBOutlet weak var ledButton8: MyButton!
    @IBOutlet weak var ledButton9: MyButton!
    @IBOutlet weak var ledButton10: MyButton!
    @IBOutlet weak var ledButton11: MyButton!
    @IBOutlet weak var ledButton12: MyButton!
    @IBOutlet weak var ledButton13: MyButton!
    @IBOutlet weak var ledButton14: MyButton!
    @IBOutlet weak var ledButton15: MyButton!
    @IBOutlet weak var ledButton16: MyButton!
    @IBOutlet weak var ledButton17: MyButton!
    @IBOutlet weak var ledButton18: MyButton!
    @IBOutlet weak var ledButton19: MyButton!
    @IBOutlet weak var ledButton20: MyButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start the scan if not connected to peripheral
        if !FloraBLEManager.sharedInstance.amIConnectedToPeripheral(){
            FloraBLEManager.sharedInstance.startScan()
        }

        //Change the buttons to the colors of the LEDs
        ledButton0.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[0])
        ledButton1.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[1])
        ledButton2.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[2])
        ledButton3.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[3])
        ledButton4.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[4])
        ledButton5.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[5])
        ledButton6.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[6])
        ledButton7.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[7])
        ledButton8.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[8])
        ledButton9.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[9])
        ledButton10.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[10])
        ledButton11.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[11])
        ledButton12.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[12])
        ledButton13.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[13])
        ledButton14.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[14])
        ledButton15.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[15])
        ledButton16.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[16])
        ledButton17.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[17])
        ledButton18.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[18])
        ledButton19.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[19])
        ledButton20.setBackgroundColor(rgb: LEDScarf.sharedInstance.valuesForLEDs[20])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ledViewController = segue.destination as! LEDViewController
        //Sets the LED we are editting for the next view Controller. Crazy large switch statement... I should learn to write better code
        let buttonSending: MyButton = sender as! MyButton
        switch buttonSending {
        case ledButton0:
            ledViewController.led = 0
        case ledButton1:
            ledViewController.led = 1
        case ledButton2:
            ledViewController.led = 2
        case ledButton3:
            ledViewController.led = 3
        case ledButton4:
            ledViewController.led = 4
        case ledButton5:
            ledViewController.led = 5
        case ledButton6:
            ledViewController.led = 6
        case ledButton7:
            ledViewController.led = 7
        case ledButton8:
            ledViewController.led = 8
        case ledButton9:
            ledViewController.led = 9
        case ledButton10:
            ledViewController.led = 10
        case ledButton11:
            ledViewController.led = 11
        case ledButton12:
            ledViewController.led = 12
        case ledButton13:
            ledViewController.led = 13
        case ledButton14:
            ledViewController.led = 14
        case ledButton15:
            ledViewController.led = 15
        case ledButton16:
            ledViewController.led = 16
        case ledButton17:
            ledViewController.led = 17
        case ledButton18:
            ledViewController.led = 18
        case ledButton19:
            ledViewController.led = 19
        case ledButton20:
            ledViewController.led = 20
        default:
            ledViewController.led = 0
        }
    }
}
