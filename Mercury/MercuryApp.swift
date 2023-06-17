//
//  MercuryApp.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/13/23.
//

import SwiftUI
import BackgroundTasks

@main
struct MercuryApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage("isNewUser")
    var isNewUser = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, appDelegate.dataController.container.viewContext)
                .sheet(isPresented: $isNewUser) {
                    WelcomeSheet()
                }
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .background:
                print("Background")
                scheduleAppRefreshRequest()
            case .active:
                print("Active")
            default:
                print("Unknown")
            }
        }
    }
}

func scheduleAppRefreshRequest() {
    @AppStorage("refreshInterval")
    var refreshInterval = 30.0    // seconds
    
    print("Scheduling... for \(refreshInterval) seconds")
    let request = BGAppRefreshTaskRequest(identifier: "com.manorajesh.MercuryApp.updateLocation")
    request.earliestBeginDate = .now.addingTimeInterval(refreshInterval)
    
    do {
        try BGTaskScheduler.shared.submit(request)
    } catch {
        print("Unable to submit background process: \(error)")
    }
}
