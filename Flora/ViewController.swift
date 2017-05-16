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
    
    fileprivate let UartServiceUUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"       // UART service UUID
    fileprivate let TxCharacteristicUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
    fileprivate var txCharacteristic: CBCharacteristic?
    fileprivate var txWriteType = CBCharacteristicWriteType.withResponse

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager (delegate: self, queue: nil)
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        if let name = peripheral.name{
            DLog("did discover " + name)
            if name == "Flora <3"{
                self.connectedPeripheral = peripheral
                peripheral.delegate = self;
                manager.connect(peripheral, options: nil);
                manager.stopScan();
                
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
                
                let command = "-255, 0, 0, 0"
                connectedPeripheral.writeValue(command.data(using: .utf8)!, for: txCharacteristic!, type: txWriteType)
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSend(_ sender: Any) {
        if(connectedPeripheral != nil){
            switch connectedPeripheral.state
            {
            case .connecting:
                DLog("peripheral thinks it is connecting")
            case .connected:
                DLog("peripheral thinks it is connected")
                connectedPeripheral.discoverServices([CBUUID(string: UartServiceUUID)])
            case .disconnected:
                DLog("peripheral thinks it is disconnected")
            case .disconnecting:
                DLog("peripheral thinks it is disconencting")
            }
            for peripheral in manager.retrieveConnectedPeripherals(withServices: [CBUUID(string: UartServiceUUID)]){
                DLog("Manager is connected to " + peripheral.name!)
            }
        }
        else{
            DLog("No peripheral was ever attempted to connect with")
        }
    }
}
