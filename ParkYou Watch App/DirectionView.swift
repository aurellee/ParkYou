//
//  DirectionView.swift
//  ParkYou Watch App
//
//  Created by Jaqueline Aurelia Langi on 27/05/24.
//

//import SwiftUI
//
//struct DirectionView: View {
//    @EnvironmentObject var beaconManager: BeaconDirection
//    var body: some View {
//        TabView {
//            VStack {
//                Spacer()
//                    .padding(.top, 20)
//                Image(systemName: "arrow.right")
//                    .font(.system(size: 78, weight: .bold))
//                    .rotationEffect(.degrees(beaconManager.angle))
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 120, height: 80)
//                    .padding(.top, 40)
//                VStack(alignment: .leading) {
//                    HStack(alignment: .lastTextBaseline, spacing: 4) {
//                        Text("\(beaconManager.distance, specifier: "%.2f")")
////                        Text("7")
//                            .font(.system(size: 24, weight: .semibold))
//                        Text("m")
//                            .font(.system(size: 24, weight: .medium))
//                            .foregroundColor(Color(UIColor(hex: 0x1364FF)))
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    HStack(alignment: .lastTextBaseline, spacing: 4) {
//                        Text("to your")
//                            .font(.system(size: 24, weight: .medium))
//                            .foregroundColor(Color(UIColor(hex: 0x1364FF)))
//                        Text("\(beaconManager.direction)")
//                            .font(.system(size: 24, weight: .semibold))
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.bottom, 60)
//                }
//                Spacer()
//            }
//            .padding(.vertical, 8)
//            .padding(.horizontal, 14)
//            .onAppear {
//                beaconManager.startScanning()
//            }
//            .navigationBarBackButtonHidden(true)
//            
//            DoneView()
//                .tabItem {
//                    Image(systemName: "checkmark.circle")
//                    Text("Done")
//                }
//                .navigationBarBackButtonHidden(true)
//        }
//        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
//        .navigationBarBackButtonHidden(true)
//    }
//}


import SwiftUI

struct DirectionView: View {
    @EnvironmentObject var beaconManager: BeaconDirection
    var body: some View {
        TabView {
            VStack {
                Spacer()
                    .padding(.top, 30)
                Image(systemName: "arrow.up")
                    .font(.system(size: 70, weight: .heavy))
                    .rotationEffect(.degrees(beaconManager.angle))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 80)
                    .padding(.top, 40)
                VStack(alignment: .leading) {
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text("\(beaconManager.distance, specifier: "%.2f")")
                            .font(.system(size: 22, weight: .bold))
                        Text("m")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(Color(UIColor(hex: 0x1364FF)))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text("to your")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(Color(UIColor(hex: 0x1364FF)))
                        Text("\(beaconManager.direction)")
                            .font(.system(size: 22, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 70)
                }
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .onAppear {
                beaconManager.startScanning()
            }
            .navigationBarBackButtonHidden(true)
            
            DoneView()
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Done")
                }
                .navigationBarBackButtonHidden(true)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .navigationBarBackButtonHidden(true)
    }
}



struct DirectionView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionView().environmentObject(BeaconDirection())
    }
}
