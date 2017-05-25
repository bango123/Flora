//
//  MyButton.swift
//  Flora
//
//  Created by Florian Richter on 5/24/17.
//  Copyright © 2017 Florian Richter. All rights reserved.
//

import UIKit

class MyButton:  UIButton{
    var isButtonSelected:Bool = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderWidth = 3.0
        if !isButtonSelected{
            layer.borderColor = UIColor.black.cgColor
        }
        else{
            layer.borderColor = UIColor.blue.cgColor
        }
        layer.cornerRadius = 10.0
        clipsToBounds = true
    }
    
    func selectButton(){
        isButtonSelected = true
        layer.borderColor = UIColor.blue.cgColor
    }
    
    func deselectButton(){
        isButtonSelected = false
        layer.borderColor = UIColor.black.cgColor
    }
    
    // 255, 255, 255 as max
    func setBackgroundColor(r: Int, g: Int, b: Int){
        let color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color, for: .highlighted)
        self.setTitleColor(color, for: .selected)
        self.backgroundColor = color
    }
    
    func setBackgroundColor(rgb: [Int]){
        setBackgroundColor(r: rgb[0], g: rgb[1], b: rgb[2])
    }
    
    func getBackgroundColor() -> [Int]{
        var r :CGFloat = 0
        var g :CGFloat = 0
        var b :CGFloat = 0
        var al :CGFloat = 0
        if let color = self.backgroundColor
        {
            color.getRed(&r, green: &g, blue: &b, alpha: &al)
        }
        
        return [Int(r * 255),Int(g * 255),Int(b * 255)]
    }
}
