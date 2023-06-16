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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, appDelegate.dataController.container.viewContext)
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
    print("Scheduling...")
    let request = BGAppRefreshTaskRequest(identifier: "com.manorajesh.MercuryApp.updateLocation")
    request.earliestBeginDate = .now.addingTimeInterval(30)
    
    do {
        try BGTaskScheduler.shared.submit(request)
    } catch {
        print("Unable to submit background process: \(error)")
    }
}
