//
//  CoordinateView.swift
//  ParkYou Watch App
//
//  Created by Jaqueline Aurelia Langi on 27/05/24.
//

import CoreBluetooth
import SwiftUI

class CoordinateView: NSObject, CBCentralManagerDelegate, ObservableObject, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var beacons: [CBPeripheral: NSNumber] = [:]
    var targetBeaconIdentifiers: [UUID] = []

    @Published var position: (x: Double, y: Double)?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        targetBeaconIdentifiers.append(UUID(uuidString: "118CAC8A-58A6-7EDF-6F79-8DAB05FFB7C6")!)
        targetBeaconIdentifiers.append(UUID(uuidString: "B894C55A-9EE0-DD13-7EA2-39064919419C")!)
        targetBeaconIdentifiers.append(UUID(uuidString: "BD18340D-7E68-FD74-20D0-92E781E7F17C")!)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        } else {
            print("Bluetooth is not available.")
        }
    }
    
    func startScanning() {
        // Ensure the central manager is powered on before scanning
        guard centralManager.state == .poweredOn else {
            print("Central manager is not powered on")
            return
        }
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // Filter peripherals based on target beacon identifiers
        if let peripheralUUID = peripheral.identifier as UUID?, targetBeaconIdentifiers.contains(peripheralUUID) {
            beacons[peripheral] = RSSI
            peripheral.delegate = self
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.readRSSI()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if let error = error {
            print("Error reading RSSI: \(error)")
            return
        }
        beacons[peripheral] = RSSI
        centralManager.cancelPeripheralConnection(peripheral)
        
        if beacons.count == 3 {
            calculatePosition()
        }
    }
    
    func calculatePosition() {
        guard beacons.count == 3 else { return }
        
        // Map beacons to the specified coordinates
        guard let rssi1 = beacons.values.first,
              let rssi2 = beacons.values.dropFirst().first,
              let rssi3 = beacons.values.first else {
            print("Error: Missing RSSI values")
            return
        }
        
        // Coordinates for the beacons
        let beacon1 = (x: 0.0, y: 0.0, rssi: rssi1)
        let beacon2 = (x: 10.0, y: 0.0, rssi: rssi2)
        let beacon3 = (x: 5.0, y: 8.66, rssi: rssi3)
        
        let distance1 = rssiToDistance(rssi: beacon1.rssi)
        let distance2 = rssiToDistance(rssi: beacon2.rssi)
        let distance3 = rssiToDistance(rssi: beacon3.rssi)
        
        let calculatedPosition = trilaterate(beacon1: (beacon1.x, beacon1.y, distance1),
                                             beacon2: (beacon2.x, beacon2.y, distance2),
                                             beacon3: (beacon3.x, beacon3.y, distance3))
        
        DispatchQueue.main.async {
            self.position = calculatedPosition
        }
    }
    
    func rssiToDistance(rssi: NSNumber) -> Double {
        let txPower = -59 // RSSI value at 1 meter
        let ratio = Double(truncating: rssi) / Double(txPower)
        if ratio < 1.0 {
            return pow(ratio, 10)
        } else {
            return 0.89976 * pow(ratio, 7.7095) + 0.111
        }
    }
    
    func trilaterate(beacon1: (x: Double, y: Double, distance: Double),
                     beacon2: (x: Double, y: Double, distance: Double),
                     beacon3: (x: Double, y: Double, distance: Double)) -> (x: Double, y: Double) {
        
        let A = 2 * (beacon2.x - beacon1.x)
        let B = 2 * (beacon2.y - beacon1.y)
        let C = beacon1.distance * beacon1.distance - beacon2.distance * beacon2.distance - beacon1.x * beacon1.x + beacon2.x * beacon2.x - beacon1.y * beacon1.y + beacon2.y * beacon2.y
        let D = 2 * (beacon3.x - beacon2.x)
        let E = 2 * (beacon3.y - beacon2.y)
        let F = beacon2.distance * beacon2.distance - beacon3.distance * beacon3.distance - beacon2.x * beacon2.x + beacon3.x * beacon3.x - beacon2.y * beacon2.y + beacon3.y * beacon3.y
        
        let x = (C - F * B / E) / (A - D * B / E)
        let y = (C - A * x) / B
        
        return (x, y)
    }
}


struct CoordinateCalculatorView: View {
    @ObservedObject var scanner = CoordinateView()
    
    var body: some View {
        VStack {
            if let position = scanner.position {
                Text("Estimated position: \(position.x), \(position.y)")
            } else {
                Text("Searching for beacons...")
            }
        }
        .onAppear {
            scanner.startScanning()
        }
    }
}


struct CoordinateCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinateCalculatorView()
    }
}
