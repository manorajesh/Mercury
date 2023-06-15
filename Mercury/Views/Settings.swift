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
    
    @AppStorage("refreshInterval")
    var refreshInterval = 10 // minutes
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Background Refresh Interval")) {
                    Stepper(value: $refreshInterval, in: 0...1000, step: 1) {
                        Text("\(refreshInterval) minutes")
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
