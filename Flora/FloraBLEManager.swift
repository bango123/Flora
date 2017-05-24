//
//  FloraBLEManager.swift
//  Flora
//
//  Created by Florian Richter on 5/18/17.
//  Copyright © 2017 Florian Richter. All rights reserved.
//

import Foundation
import CoreBluetooth

class FloraBLEManager : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    // Main
    static let sharedInstance = FloraBLEManager()
    var manager: CBCentralManager!
    var connectedPeripheral: CBPeripheral!
    var connectingToPeripheral = false
    var connectedToPeripheral = false
    var discoveredServices = false
    
    var sendingMessage = false
    var nextCommand: String?
    
    fileprivate let UartServiceUUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"       // UART service UUID
    fileprivate let TxCharacteristicUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
    fileprivate var txCharacteristic: CBCharacteristic?
    fileprivate var txWriteType = CBCharacteristicWriteType.withResponse
    
    override init(){
        super.init()
        manager = CBCentralManager (delegate: self, queue: nil)
    }
    
    func startScan(){
        if manager.state == .poweredOn{
            DLog("Start Scanning")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "startScanning"), object: nil)
            manager.scanForPeripherals(withServices: nil, options: nil)
        }
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
            DLog("BLE is Resetting")
        case.poweredOff:
            DLog("BLE service is powered off")
        case.poweredOn:
            DLog("BLE service is powered on")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "canStartScanning"), object: nil)
//            DLog("Start Scanning")
//            //Starts to scan for peripherals, the "didDiscover" function will be the next to occur
//            manager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    //Executes when a peripheral is found. If it is Flora connect to the device
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let name = peripheral.name{
            DLog("did discover " + name)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "connectingToFlora"), object: nil)
            
            //Found Flora and begings the connection!!
            if name == "Flora <3"{
                self.connectingToPeripheral = true
                
                //Starts the connection
                self.connectedPeripheral = peripheral
                peripheral.delegate = self;
                manager.connect(peripheral, options: nil);
                manager.stopScan();
                
                DLog("Begin connecting to Flora")
                
                //Waits here till both the peripheral and the bluetooth manager say they are connected
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(FloraBLEManager.waitTillManagerConnected),userInfo: nil, repeats: connectedToPeripheral)
            }
        }
    }
    
    func waitTillManagerConnected(){
        if amIConnectedToPeripheral(){
            //If we are connected to peripheral, we should start to scan to discover services
            self.connectingToPeripheral = false
            self.connectedToPeripheral = true
            DLog("Connected to Flora")
            connectedPeripheral.discoverServices([CBUUID(string: UartServiceUUID)])
        }
        else{
            return
        }
    }
    
    //Returns true if we are connected to peripheral
    func amIConnectedToPeripheral() -> Bool{
        var managerConnected = false;
        for peripheral in manager.retrieveConnectedPeripherals(withServices: [CBUUID(string: UartServiceUUID)]){
            if peripheral.name! == "Flora <3"{
                managerConnected = true;
            }
        }
        if connectedPeripheral.state == .connected && managerConnected{
            return true
        }
        return false
    }

    //Discovers the services of the bluetooth peripheral
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices: Error?){
        DLog(peripheral.name! + " found a service");
        for service in peripheral.services!{
            if service.uuid.uuidString.caseInsensitiveCompare(UartServiceUUID) == .orderedSame{
                DLog("Found UART capability")
                connectedPeripheral.discoverCharacteristics([CBUUID(string: TxCharacteristicUUID)], for: service)
            }
        }
    }
    
    //Discoveres the charactersitcs, once this has been completed we have all the information we need from the peripheral
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,error: Error?){
        DLog("Discovered characteristics for our service")
        for characteristic in service.characteristics!{
            if characteristic.uuid.uuidString.caseInsensitiveCompare(TxCharacteristicUUID) == .orderedSame {
                txCharacteristic = characteristic
                txWriteType = characteristic.properties.contains(.writeWithoutResponse) ? .withoutResponse:.withResponse
                DLog("Uart: detected TX with txWriteType: \(txWriteType.rawValue)")
                discoveredServices = true
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "connectedToFlora"), object: nil)
                
                //let command = "-0, 255, 0, 0"
                //connectedPeripheral.writeValue(command.data(using: .utf8)!, for: txCharacteristic!, type: txWriteType)
            }
        }
    }
    
    
    func sendMessageToPeripheral(msg: String){
        guard amIConnectedToPeripheral() else {
            self.connectedToPeripheral = false
            self.discoveredServices = false
            startScan()
            return
        }
        
        //This makes sure that the newest command is sent after the one currently being sent is done being sent
        if(!sendingMessage){
            sendingMessage = true
            connectedPeripheral.writeValue(msg.data(using: .utf8)!, for: txCharacteristic!, type: txWriteType)
            
            let when = DispatchTime.now() + 0.05
            
            //This will run after our previous message has been sent!
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.sendingMessage = false
                if let command = self.nextCommand{
                    self.nextCommand = nil
                    self.sendMessageToPeripheral(msg: command)
                }
            }
        }
            
        else{
            nextCommand = msg
        }
    }
    
    func sendLEDCommand(LED: Int, rgb: [Int]){
        let red = rgb[0]
        let green = rgb[1]
        let blue = rgb[2]
        
        let message = "-\(red),\(green),\(blue),\(LED)"
        
        //DLog(message)
        sendMessageToPeripheral(msg: message)
    }
}
