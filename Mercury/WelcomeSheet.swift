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
            VStack(alignment: .leading) {
                Divider().padding([.top, .trailing, .leading])
                Text("Getting started with \(Bundle.main.infoDictionary!["CFBundleName"] as! String) is as easy as closing the app! However, to automatically record your location, the app will always need it.")
                    .padding()
                Text("Note: your location data will NEVER leave your device")
                    .bold()
                    .padding(.leading)
                
                Divider().padding([.top, .trailing, .leading])
                
                Text("If you are not comfortable with having the app automatically record your location, you can use the 'When In Use' option instead.\n\nHowever, to enable location access even when the device is asleep, go to:")
                    .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "gear")
                            .foregroundColor(.gray)
                        Text("Open the ") + Text("Settings").bold() + Text(" app")
                        
                    }.padding(7)
                    
                    HStack(alignment: .top) {
                        Image(systemName: "hand.raised.fill")
                            .foregroundColor(.blue)
                        Text("Select ") + Text("Privacy & Security").bold()
                        
                    }.padding(7)
                    
                    HStack(alignment: .top) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.red)
                        Text("Select ") + Text("Location Services").bold()
                        
                    }.padding(7)
                    
                    HStack(alignment: .top) {
                        Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                            .clipShape(Circle())
                        Text("Select ") + Text("Mercury").bold()
                    }.padding(7)
                    
                    HStack(alignment: .top) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                        Text("Change to ") + Text("Always").bold()
                    }.padding(7)
                }
                .padding()
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
