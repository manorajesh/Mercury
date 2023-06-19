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
    
    @State var fileImportURL = URL(string: "www.google.com")
    
    @State private var isPresentingConfirm: Bool = false
    @State private var isPresentingWelcome: Bool = false
    @State private var isImporting: Bool = false
    @State private var isImportingConfirm: Bool = false
    
    @State private var showDocumentPicker = false
    @State private var fileURL: URL?
    
    @AppStorage("refreshInterval")
    var refreshInterval = 30.0    // seconds
    
    @AppStorage("appRefreshes")
    var appRefreshes = 0        // default
    
    @AppStorage("noAppRefresh")
    var noAppRefresh = false       // default
    
    @AppStorage("useLA")
    var useLA = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: SettingsHelp(title: "Background Refresh Interval", alertTitle: "About Background Refreshes", alertText: "Please note that the interval is a suggestion to the system. The system may adjust the timing based on factors like network conditions and battery level."), footer: Text("More frequent refreshes will make your travel log more accurate while consuming more battery life.")) {
                    Toggle("Disable Refreshes", isOn: $noAppRefresh)
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
                .foregroundColor(noAppRefresh ? .gray : .none)
                
                Section {
                    Toggle("Lock with Face ID and Passcode", isOn: $useLA)
                }
                
                Section {
                    Button("Show Welcome") {
                        isPresentingWelcome.toggle()
                    }
                    .sheet(isPresented: $isPresentingWelcome) {
                        WelcomeSheet()
                    }
                }
                
                Section(header: Text("Data Management")) {
                    ShareLink("Export Locations", item: exportData(coordinates) ?? URL(string: "https://www.google.com")!)
                    
                    Button {
                        isImporting = true
                    } label: {
                        Label("Import Locations",  systemImage: "square.and.arrow.down")
                    }
                    .sheet(isPresented: $isImporting) {
                        DocumentPicker(fileURL: $fileURL)
                            .ignoresSafeArea(.container)
                    }
                    .onChange(of: fileURL) { newURL in
                        isImportingConfirm = true
                    }
                    .confirmationDialog("Are you sure?", isPresented: $isImportingConfirm) {
                        Button("Append all Locations?", role: .destructive) {
                            importData(from: fileURL!, moc: moc)
                            print("Selected file URL: \(fileURL!)")
                        }
                    } message: {
                        Text("You cannot undo this action")
                    }
                    
                    Button(role: .destructive) {
                        isPresentingConfirm = true
                    } label: {
                        Label("Delete All \(coordinates.count) Locations",  systemImage: "trash")
                            .foregroundColor(.red)
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
