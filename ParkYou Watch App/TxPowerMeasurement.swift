//
//  TxPowerMeasurement.swift
//  ParkYou Watch App
//
//  Created by Jaqueline Aurelia Langi on 27/05/24.
//

import SwiftUI
import CoreBluetooth

struct TxMeasurementView: View {
    var body: some View {
        Text("Measuring TxPower... \(txPowerMeasurement)")
    }
}

class TxPowerMeasurement: NSObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager!
    private var targetPeripheral: CBPeripheral?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        } else {
            print("Bluetooth is not available.")
        }
    }
    
    func startScanning() {
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        print("Started scanning for peripherals")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered peripheral: \(peripheral.identifier), RSSI: \(RSSI)")
        
        // Assuming this is the target peripheral
        targetPeripheral = peripheral
        centralManager.stopScan()
        
        // Calculate txPower (use RSSI at 1 meter)
        let txPower = RSSI.doubleValue
        print("Estimated txPower: \(txPower)")
        // Store or use txPower as needed
    }
}

// Usage
let txPowerMeasurement = TxPowerMeasurement()
