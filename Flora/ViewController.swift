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
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var connectionStateLabel: UILabel!
    
    
    var manager: CBCentralManager!
    var connectedPeripheral: CBPeripheral!
    var connectingToPeripheral = false
    var connectedToPeripheral = false
    
    fileprivate let UartServiceUUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"       // UART service UUID
    fileprivate let TxCharacteristicUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
    fileprivate var txCharacteristic: CBCharacteristic?
    fileprivate var txWriteType = CBCharacteristicWriteType.withResponse
    
    var alertController: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager (delegate: self, queue: nil)
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        if let name = peripheral.name{
            DLog("did discover " + name)
            
            //Found Flora and begings the connection!!
            if name == "Flora <3"{
                self.connectingToPeripheral = true
                
                //Starts the connection
                self.connectedPeripheral = peripheral
                peripheral.delegate = self;
                manager.connect(peripheral, options: nil);
                manager.stopScan();
                
                DLog("Begin connecting to Flora")
                self.alertController.message = "Connecting to Flora"
                self.alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) -> Void in
                    self.manager.cancelPeripheralConnection(self.connectedPeripheral)
                    self.connectedPeripheral = nil
                }))
                
                //keeps repeating till both the peripheral and the bluetooth manager say they are connected
               Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.waitTillManagerConnected),userInfo: nil, repeats: connectingToPeripheral)
            }
        }
    }
    
    func waitTillManagerConnected(){
        if !self.connectedToPeripheral && self.connectingToPeripheral{
            DLog("Connecting to Flora")
            var managerConnected = false;
            for peripheral in manager.retrieveConnectedPeripherals(withServices: [CBUUID(string: UartServiceUUID)]){
                if peripheral.name! == "Flora <3"{
                    managerConnected = true;
                }
            }
            if connectedPeripheral.state == .connected && managerConnected{
                self.connectingToPeripheral = false
                self.connectedToPeripheral = true
                self.alertController.message = "Discovering Services"
                DLog("Connected to Flora")
                connectedPeripheral.discoverServices([CBUUID(string: UartServiceUUID)])
            }
        }
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
            DLog("BLE is Resetting")
        case.poweredOff:
            DLog("BLE service is powered off")
        case.poweredOn:
            DLog("BLE service is powered on")
            DLog("Start Scanning")
            manager.scanForPeripherals(withServices: nil, options: nil)
            DispatchQueue.main.async(execute: {[unowned self] in
                self.alertController = UIAlertController(title: nil, message: "Finding Flora", preferredStyle: .alert)
                self.present(self.alertController, animated: true, completion:nil)
            })
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices: Error?){
        DLog(peripheral.name! + " found a service");
        for service in peripheral.services!{
            if service.uuid.uuidString.caseInsensitiveCompare(UartServiceUUID) == .orderedSame{
                DLog("Found UART capability")
                connectedPeripheral.discoverCharacteristics([CBUUID(string: TxCharacteristicUUID)], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,error: Error?){
        DLog("Discovered characteristics for our service")
        for characteristic in service.characteristics!{
            if characteristic.uuid.uuidString.caseInsensitiveCompare(TxCharacteristicUUID) == .orderedSame {
                txCharacteristic = characteristic
                txWriteType = characteristic.properties.contains(.writeWithoutResponse) ? .withoutResponse:.withResponse
                DLog("Uart: detected TX with txWriteType: \(txWriteType.rawValue)")
                self.alertController.dismiss(animated: true, completion: nil)
                
                let command = "-0, 255, 0, 0"
                connectedPeripheral.writeValue(command.data(using: .utf8)!, for: txCharacteristic!, type: txWriteType)
            }
        }
    }
    
    func stillConnectedToPeripheral() -> Bool{
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSend(_ sender: Any) {
        sendMessageToPeripheral(msg: "-255,0,100,0")
    }
    

    
    func sendMessageToPeripheral(msg: String){
        guard stillConnectedToPeripheral() else {
            self.connectedToPeripheral = false
            manager.scanForPeripherals(withServices: nil, options: nil)
            DispatchQueue.main.async(execute: {[unowned self] in
                self.alertController = UIAlertController(title: nil, message: "Finding Flora", preferredStyle: .alert)
                self.present(self.alertController, animated: true, completion:nil)
            })
            return
        }
        connectedPeripheral.writeValue(msg.data(using: .utf8)!, for: txCharacteristic!, type: txWriteType)
    }
}
