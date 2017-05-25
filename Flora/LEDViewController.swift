//
//  LEDViewController.swift
//  Flora
//
//  Created by Florian Richter on 5/21/17.
//  Copyright © 2017 Florian Richter. All rights reserved.
//

import UIKit

class LEDViewController: FloraViewController {
    
    @IBOutlet weak var colorButton1: MyButton!
    @IBOutlet weak var colorButton2: MyButton!
    @IBOutlet weak var colorButton3: MyButton!
    @IBOutlet weak var colorButton4: MyButton!
    @IBOutlet weak var colorButton5: MyButton!
    @IBOutlet weak var colorButton6: MyButton!
    @IBOutlet weak var colorButton7: MyButton!
    @IBOutlet weak var colorButton8: MyButton!
    @IBOutlet weak var colorButton9: MyButton!
    
    @IBOutlet weak var colorDisplay: MyButton!

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    var currentButton: MyButton?
    var led: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get previously used colors for the tool!
        let defaults = UserDefaults.standard
        if let colorData = defaults.array(forKey: "LED_Edditting_Data"){
            colorButton1.setBackgroundColor(rgb: colorData[0] as! [Int])
            colorButton2.setBackgroundColor(rgb: colorData[1] as! [Int])
            colorButton3.setBackgroundColor(rgb: colorData[2] as! [Int])
            colorButton4.setBackgroundColor(rgb: colorData[3] as! [Int])
            colorButton6.setBackgroundColor(rgb: colorData[4] as! [Int])
            colorButton7.setBackgroundColor(rgb: colorData[5] as! [Int])
            colorButton8.setBackgroundColor(rgb: colorData[6] as! [Int])
            colorButton9.setBackgroundColor(rgb: colorData[7] as! [Int])
            
        }
            //Otherwise we can use this preset
        else{
            colorButton1.setBackgroundColor(rgb: [255,  0,     0])
            colorButton2.setBackgroundColor(rgb: [0,    255,   0])
            colorButton3.setBackgroundColor(rgb: [0,    0,     255])
            colorButton4.setBackgroundColor(rgb: [255,  255,   0])
            colorButton6.setBackgroundColor(rgb: [255,  0,     255])
            colorButton7.setBackgroundColor(rgb: [0,    255,   255])
            colorButton8.setBackgroundColor(rgb: [0,    0,      0])
            colorButton9.setBackgroundColor(rgb: [255,  255,    255])
        }
        

        //Set button 5 to be the value which is currently on the LED
        currentButton = colorButton5
        colorButton5.selectButton()
        
        //Make the color of button 5 be the one that is currently being editted
        if let currentLED = led{
            redSlider.value = Float(LEDScarf.sharedInstance.valuesForLEDs[currentLED][0])
            greenSlider.value = Float(LEDScarf.sharedInstance.valuesForLEDs[currentLED][1])
            blueSlider.value = Float(LEDScarf.sharedInstance.valuesForLEDs[currentLED][2])
            onSliderUsed(redSlider)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Store the values used in our LED Editor
        let defaults = UserDefaults.standard
        let colorArray = [colorButton1.getBackgroundColor(), colorButton2.getBackgroundColor(), colorButton3.getBackgroundColor(), colorButton4.getBackgroundColor(), colorButton6.getBackgroundColor(), colorButton7.getBackgroundColor(), colorButton8.getBackgroundColor(), colorButton9.getBackgroundColor()]
        defaults.set(colorArray, forKey: "LED_Edditting_Data")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onColorButton(_ sender: MyButton) {
        currentButton?.deselectButton()
        currentButton = sender
        if let button = currentButton{
            button.selectButton()
            
            let rgb = button.getBackgroundColor()
            colorDisplay.setBackgroundColor(rgb: rgb)
            
            redSlider.value = Float(rgb[0])
            greenSlider.value = Float(rgb[1])
            blueSlider.value = Float(rgb[2])
        
            LEDScarf.sharedInstance.setLED(LED: led!, rgb: rgb)
        }
    }
    
    @IBAction func onSliderUsed(_ sender: UISlider) {
        let r = Int(redSlider.value)
        let g = Int(greenSlider.value)
        let b = Int(blueSlider.value)
        let newColor = [r,g,b]
        
        colorDisplay.setBackgroundColor(rgb: newColor)
        if let button = currentButton{
            button.setBackgroundColor(rgb: newColor)
        }
        LEDScarf.sharedInstance.setLED(LED: led!, rgb: newColor)
    }
}
