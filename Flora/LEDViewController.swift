//
//  LEDViewController.swift
//  Flora
//
//  Created by Florian Richter on 5/21/17.
//  Copyright © 2017 Florian Richter. All rights reserved.
//

import UIKit

class LEDViewController: FloraViewController {
    
    @IBOutlet weak var colorButton1: UIButton!
    @IBOutlet weak var colorButton2: UIButton!
    @IBOutlet weak var colorButton3: UIButton!
    @IBOutlet weak var colorButton4: UIButton!
    @IBOutlet weak var colorButton5: UIButton!
    @IBOutlet weak var colorButton6: UIButton!
    @IBOutlet weak var colorButton7: UIButton!
    @IBOutlet weak var colorButton8: UIButton!
    @IBOutlet weak var colorButton9: UIButton!
    
    @IBOutlet weak var colorDisplay: UIButton!

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    var currentButton: UIButton?
    var led: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set button 5 to be the value which is currently on the LED
        currentButton = colorButton5
        //Make the color of button 5 be the one that is currently being editted
        if let currentLED = led{
            redSlider.value = Float(LEDScarf.sharedInstance.valuesForLEDs[currentLED][0])
            greenSlider.value = Float(LEDScarf.sharedInstance.valuesForLEDs[currentLED][1])
            blueSlider.value = Float(LEDScarf.sharedInstance.valuesForLEDs[currentLED][2])
            onSliderUsed(redSlider)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onColorButton(_ sender: UIButton) {
        currentButton = sender
        if let color = currentButton?.backgroundColor{
            colorDisplay.backgroundColor = color
            
            var r :CGFloat = 0
            var g :CGFloat = 0
            var b :CGFloat = 0
            var al :CGFloat = 0
            color.getRed(&r, green: &g, blue: &b, alpha: &al)
            
            redSlider.value = Float(255*r)
            greenSlider.value = Float(255*g)
            blueSlider.value = Float(255*b)
        
            let newColor = [Int(redSlider.value),Int(greenSlider.value),Int(blueSlider.value)]
            LEDScarf.sharedInstance.setLED(LED: led!, rgb: newColor)
        }
    }
    
    @IBAction func onSliderUsed(_ sender: UISlider) {
        let r = redSlider.value
        let g = greenSlider.value
        let b = blueSlider.value
        let color = UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: 1.0)
            
        colorDisplay.backgroundColor = color
        if let button = currentButton{
            button.backgroundColor = color
        }
        
        let newColor = [Int(r),Int(g),Int(b)]
        LEDScarf.sharedInstance.setLED(LED: led!, rgb: newColor)
    }
    
}
