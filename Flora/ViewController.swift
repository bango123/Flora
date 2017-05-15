//
//  ViewController.swift
//  Flora
//
//  Created by Florian Richter on 5/14/17.
//  Copyright © 2017 Florian Richter. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var manager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager (delegate: self, queue: nil)
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name{
            DLog("did discover " + name)
            if name == "Adafruit Bluefruit LE"{
                self.connectedPeripheral = peripheral
                
                manager.connect(peripheral, options: nil);
                manager.stopScan();
            }
        }
        
        //manager.connectPeripheral(peripheral, options:nil)
        
        //manager.stopScan()
        
    }
    
    
    
    private func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        DLog("connected!")
    }
    
    private func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        DLog("disconnected!")
    }
    
    
    private func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        DLog("failed")
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        DLog("Checking")
        switch(central.state)
        {
        case.unsupported:
            DLog("BLE is not supported")
        case.unauthorized:
            DLog("BLE is unauthorized")
        case.unknown:
            DLog("BLE is Unknown")
        case.resetting:
            print("BLE is Resetting")
        case.poweredOff:
            print("BLE service is powered off")
        case.poweredOn:
            print("BLE service is powered on")
            print("Start Scanning")
            manager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
