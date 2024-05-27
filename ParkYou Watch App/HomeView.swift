//
//  ContentView.swift
//  ParkYou Watch App
//
//  Created by Jaqueline Aurelia Langi on 27/05/24.
//

import SwiftUI

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

struct HomeView: View {
    @EnvironmentObject var beaconManager: BeaconDirection
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center) {
                Spacer()
                Image("car")
                    .frame(width: 10, height: 14)
                    .padding(.top, 50)
                Text("Find My Car")
                    .font(.system(size: 20, weight: .regular))
                    .padding(.top, 26)
                Spacer()
                Spacer()
                NavigationLink(destination: DirectionView() ) {
                    Text("Locate")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.white)
                        .frame(width: 150, height: 46)
                        .background(Color(UIColor(hex: 0x066aff)))
                        .cornerRadius(24)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 38)
                Spacer()
            }
            .padding(14)
            .navigationBarBackButtonHidden(true)
            .buttonStyle(PlainButtonStyle())
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            beaconManager.reset()
        }
        .navigationBarBackButtonHidden(true)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(BeaconDirection())
    }
}

