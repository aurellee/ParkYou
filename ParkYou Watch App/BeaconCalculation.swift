//
//  BeaconCalculation.swift
//  ParkYou Watch App
//
//  Created by Jaqueline Aurelia Langi on 27/05/24.
//

import SwiftUI
import CoreBluetooth
import Combine
import WatchKit

class BeaconDirection: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager!
    private var peripherals: [CBPeripheral] = []
    @Published var beaconData: [UUID: Int] = [:] // Store RSSI values for beacons
    @Published var distance: Double = 0.0
    @Published var direction: String = ""
    @Published var angle: Double = 0.0

    let beaconAUUID = UUID(uuidString: "C0AF567A-9429-7E6B-DCB9-F8FBC83B291A")!
    let beaconBUUID = UUID(uuidString: "336B691E-C2A1-F656-9CAA-8133BA7D7A0C")!
    let beaconCUUID = UUID(uuidString: "2C643CE1-AEC4-F853-AE03-7E7B5A41AA77")!
    let targetBeaconUUID = UUID(uuidString: "12D87B3D-E4D1-CB00-571C-79B2F818CC80")!

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
            beaconData[peripheral.identifier] = RSSI.intValue
            peripherals.append(peripheral)
            calculateDistanceAndDirection()
        }
    }

    func calculateDistanceAndDirection() {
        guard let rssiA = beaconData[beaconAUUID], let rssiB = beaconData[beaconBUUID], let rssiC = beaconData[beaconCUUID], let targetRSSI = beaconData[targetBeaconUUID] else {
            print("Not all beacon RSSI values available")
            return
        }

        let distanceA = calculateDistance(rssi: rssiA)
        let distanceB = calculateDistance(rssi: rssiB)
        let distanceC = calculateDistance(rssi: rssiC)
        let targetDistance = calculateDistance(rssi: targetRSSI)

        print("Distances - A: \(distanceA), B: \(distanceB), C: \(distanceC), Target: \(targetDistance)")

        let (x, y) = trilateration(distanceA: distanceA, distanceB: distanceB, distanceC: distanceC)
        print("Estimated position of Apple Watch: (\(x), \(y))")

        distance = targetDistance
        let (adjustedAngle, adjustedDirection) = calculateAngleAndDirection(x: x, y: y)
        angle = adjustedAngle
        direction = adjustedDirection

        triggerHapticFeedback()
    }

    func calculateDistance(rssi: Int) -> Double {
        let txPower = -69 // Adjust this value based on your beacon's txPower
        return pow(10.0, (Double(txPower) - Double(rssi)) / 20.0)
    }

    func trilateration(distanceA: Double, distanceB: Double, distanceC: Double) -> (Double, Double) {
        let xA: Double = 0.0
        let yA: Double = 0.0
        let xB: Double = 10.0
        let yB: Double = 0.0
        let xC: Double = 5.0
        let yC: Double = 10.0

        let A = 2 * (xB - xA)
        let B = 2 * (yB - yA)
        let C = distanceA * distanceA - distanceB * distanceB - xA * xA + xB * xB - yA * yA + yB * yB
        let D = 2 * (xC - xB)
        let E = 2 * (yC - yB)
        let F = distanceB * distanceB - distanceC * distanceC - xB * xB + xC * xC - yB * yB + yC * yC

        let x = (C * E - F * B) / (E * A - B * D)
        let y = (C * D - A * F) / (B * D - A * E)

        return (x, y)
    }

    func calculateAngleAndDirection(x: Double, y: Double) -> (Double, String) {
        let angle = atan2(y, x) * 180 / .pi
        var direction: String

        let normalizedAngle = (angle + 360).truncatingRemainder(dividingBy: 360)

        if normalizedAngle >= 45 && normalizedAngle < 135 {
            direction = "right"
        } else if normalizedAngle >= 135 && normalizedAngle < 225 {
            direction = "back"
        } else if normalizedAngle >= 225 && normalizedAngle < 315 {
            direction = "left"
        } else {
            direction = "front"
        }

        return (angle, direction)
    }

    func triggerHapticFeedback() {
            if distance < 0.1 {
                WKInterfaceDevice.current().play(.success)
                WKInterfaceDevice.current().play(.notification) // Add sound feedback here
            } else if distance < 1 {
                WKInterfaceDevice.current().play(.directionUp)
            } else {
                // No need to play haptic feedback if the distance is more than 1 meter
                return
            }
        }
        
        func reset() {
            beaconData.removeAll()
            distance = 0.0
            direction = ""
            angle = 0.0
    }
}
