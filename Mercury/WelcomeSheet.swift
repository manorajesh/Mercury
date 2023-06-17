//
//  WelcomeSheet.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/16/23.
//

import SwiftUI

struct WelcomeSheet: View {
    @StateObject var locationDataManager = LocationDataManager()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Getting started with \(Bundle.main.infoDictionary!["CFBundleName"] as! String) is as easy as closing the app! ")
                Text("However, to automatically record your location, the app will always need it.")
                Text("Note: your location data will NEVER leave your device")
                    .bold()
                Spacer()
                
                Button {
                    locationDataManager.locationManager.requestAlwaysAuthorization()
                } label: {
                    Text("Request Location Access")
                }
            }
            .navigationTitle("Welcome! 👋")
        }
        .padding()
    }
}

struct WelcomeSheet_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeSheet()
    }
}
