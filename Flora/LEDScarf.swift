//
//  LEDScarf.swift
//  Flora
//
//  Created by Florian Richter on 5/21/17.
//  Copyright © 2017 Florian Richter. All rights reserved.
//

import Foundation

class LEDScarf : NSObject{
    var valuesForLEDs = Array(repeating: Array(repeating: 0, count: 3), count: 21)
    static let sharedInstance = LEDScarf()
    
    override init(){
        super.init()
    }
    
    func setLED(LED: Int, rgb: [Int]){
        valuesForLEDs[LED] = rgb
        FloraBLEManager.sharedInstance.sendLEDCommand(LED: LED, rgb: rgb)
    }
    
    func getLED(LED: Int) -> [Int]{
        return valuesForLEDs[LED]
    }
    
    func setWholeArray(rgbLEDData: [[Int]]){
        //valuesForLEDs = rgbLEDData
        
        for index in 0...20{
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.setLED(LED: index, rgb: rgbLEDData[index])
            }
        }

    }
}
