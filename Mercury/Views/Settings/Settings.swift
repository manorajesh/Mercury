//
//  Settings.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/14/23.
//

import SwiftUI

struct Settings: View {
    @FetchRequest(sortDescriptors: []) var coordinates: FetchedResults<Coordinates>
    @Environment(\.managedObjectContext) var moc
    
    @State private var isPresentingConfirm: Bool = false
    @State private var isPresentingWelcome: Bool = false
    
    @AppStorage("refreshInterval")
    var refreshInterval = 30.0    // seconds
    
    @AppStorage("appRefreshes")
    var appRefreshes = 0        // default
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: SettingsHelp(title: "Background Refresh Interval", alertTitle: "About Background Refreshes", alertText: "Please note that the interval is a suggestion to the system. The system may adjust the timing based on factors like network conditions and battery level."), footer: Text("More frequent refreshes will make your travel log more accurate while consuming more battery life.")) {
                    Stepper(value: $refreshInterval, in: 30...1000, step: 5) {
                        Text("\(String(format: "%.0f", refreshInterval)) seconds")
                    }
                    HStack {
                        Text("Background Refreshes")
                        Spacer()
                        Text("\(appRefreshes)")
                            .foregroundColor(.gray)
                    }
                }
                
                Section {
                    Button("Show Welcome") {
                        isPresentingWelcome.toggle()
                    }
                    .sheet(isPresented: $isPresentingWelcome) {
                        WelcomeSheet()
                    }
                }
                
                
                Section {
                    Button("Delete All \(coordinates.count) Locations", role: .destructive) {
                        isPresentingConfirm = true
                    }
                    .tint(.red)
                    .confirmationDialog("Are you sure?",
                                        isPresented: $isPresentingConfirm) {
                        Button("Delete?", role: .destructive) {
                            for coordinate in coordinates {
                                moc.delete(coordinate)
                            }
                            
                            try? moc.save()
                        }
                    } message: {
                        Text("You cannot undo this action")
                    }
                }
            }
            .navigationBarTitle(Text("Settings"))
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
