//
//  BeaconDetectorView.swift
//  ParkYou Watch App
//
//  Created by Jaqueline Aurelia Langi on 27/05/24.
//

import SwiftUI
import CoreBluetooth
import Combine

class BeaconDetector: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager!
    private var peripherals: [CBPeripheral] = []
    @Published var beaconData: [UUID: Int] = [:] // Store RSSI values for beacons
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            print("Scanning for peripherals...")
        } else {
            print("Bluetooth is not powered on.")
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            startScanning()
        case .poweredOff:
            print("Bluetooth is powered off")
        case .resetting:
            print("Bluetooth is resetting")
        case .unauthorized:
            print("Bluetooth is unauthorized")
        case .unsupported:
            print("Bluetooth is unsupported")
        case .unknown:
            print("Bluetooth state is unknown")
        @unknown default:
            print("Unknown Bluetooth state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if peripheral.name != nil {
            print("Peripheral: \(peripheral), rssi : \(RSSI.intValue)")
            beaconData[peripheral.identifier] = RSSI.intValue
            peripherals.append(peripheral)
        }
    }
    
    // Function to calculate direction based on RSSI
    func calculateDirection() -> String? {
        // Ensure there are at least 3 beacons detected
        guard beaconData.count >= 3 else { return nil }
        
        // Sort beacons by RSSI values
        let sortedBeacons = beaconData.sorted { $0.value > $1.value }
        
        // Implement a basic triangulation or direction finding algorithm
        // Here we simply point to the strongest signal
        if let strongestBeacon = sortedBeacons.first {
            return "Move towards beacon \(strongestBeacon.key)"
        }
        
        return nil
    }
}

struct BeaconDetectorView: View {
    @ObservedObject var beaconManager = BeaconDetector()
    
    var body: some View {
        VStack {
            if let direction = beaconManager.calculateDirection() {
                Text(direction)
                    .padding()
            } else {
                Text("Searching..")
                    .padding()
            }
        }
        .onAppear {
            beaconManager.startScanning()
        }
    }
}


struct BeaconDetectorView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconDetectorView()
    }
}
