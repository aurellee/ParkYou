//
//  DoneView.swift
//  ParkYou Watch App
//
//  Created by Jaqueline Aurelia Langi on 27/05/24.
//

//import SwiftUI
//
//struct DoneView: View {
//    @EnvironmentObject var beaconManager: BeaconDirection
//    @State private var animate = false
//    
//    var body: some View {
//        VStack {
//            Spacer()
//                .padding(.top, 14)
//            Text("Done")
//                .font(.system(size: 22, weight: .medium))
//                .padding(.bottom, 1)
//            ZStack {
//                Circle()
//                    .fill(Color(UIColor(hex: 0x1364FF)).opacity(0.1))
//                    .frame(width: 114, height: 114)
//                    .scaleEffect(animate ? 1 : 0)
//                    .animation(Animation.easeOut(duration: 2).repeatForever(autoreverses: true).delay(0), value: animate)
//                Circle()
//                    .fill(Color(UIColor(hex: 0x1364FF)).opacity(0.3))
//                    .frame(width: 96, height: 96)
//                    .scaleEffect(animate ? 1 : 0)
//                    .animation(Animation.easeOut(duration: 2).repeatForever(autoreverses: true).delay(0), value: animate)
//                Circle()
//                    .fill(Color(UIColor(hex: 0x1364FF)).opacity(0.3))
//                    .frame(width: 78, height: 78)
//                    .scaleEffect(animate ? 1 : 0)
//                    .animation(Animation.easeOut(duration: 2).repeatForever(autoreverses: true).delay(0), value: animate)
//                Circle()
//                    .fill(Color(UIColor(hex: 0x1364FF)).opacity(1))
//                    .frame(width: 60, height: 60)
//                    .scaleEffect(animate ? 1 : 1)
//                    .animation(Animation.easeOut(duration: 2).repeatForever(autoreverses: false), value: animate)
//                
//                NavigationLink(destination: HomeView().onAppear {
//                    beaconManager.reset()
//                }) {
//                    Image(systemName: "checkmark")
//                        .foregroundColor(.white)
//                        .font(.system(size: 28, weight: .semibold))
//                        .background(Color.clear)
//                        .shadow(color: .clear, radius: 0, x: 0, y: 0)
//                }
//                .buttonStyle(PlainButtonStyle())
//            }
//            .onAppear {
//                animate = true
//            }
//            .navigationBarBackButtonHidden(true)
//        }
//        .padding(10)
//        .navigationBarBackButtonHidden(true)
//    }
//}


import SwiftUI

struct DoneView: View {
    @EnvironmentObject var beaconManager: BeaconDirection
    @State private var animate = false
    
    var body: some View {
        VStack {
            Spacer()
                .padding(.top, 20)
            Text("Done")
                .font(.system(size: 24, weight: .medium))
//                .padding(.bottom, 1)
            ZStack {
                Circle()
                    .fill(Color(UIColor(hex: 0x1364FF)).opacity(0.3))
                    .frame(width: 114, height: 114)
                    .scaleEffect(animate ? 1 : 0)
                    .animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: true).delay(0.2), value: animate)
                Circle()
                    .fill(Color(UIColor(hex: 0x1364FF)).opacity(0.4))
                    .frame(width: 96, height: 96)
                    .scaleEffect(animate ? 1 : 0)
                    .animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: true).delay(0.2), value: animate)
                Circle()
                    .fill(Color(UIColor(hex: 0x1364FF)).opacity(0.5))
                    .frame(width: 78, height: 78)
                    .scaleEffect(animate ? 1 : 0)
                    .animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: true).delay(0.2), value: animate)
                Circle()
                    .fill(Color(UIColor(hex: 0x1364FF)).opacity(1))
                    .frame(width: 60, height: 60)
                    .scaleEffect(animate ? 1 : 1)
                    .animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: false), value: animate)
                
                NavigationLink(destination: HomeView()) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .semibold))
                        .background(Color.clear)
                        .shadow(color: .clear, radius: 0, x: 0, y: 0)
                }
                .buttonStyle(PlainButtonStyle())
                .onTapGesture {
                    beaconManager.reset()
                }
            }
            .onAppear {
                animate = true
            }
        }
        .padding(10)
    }
}


struct DoneView_Previews: PreviewProvider {
    static var previews: some View {
        DoneView().environmentObject(BeaconDirection())
    }
}
