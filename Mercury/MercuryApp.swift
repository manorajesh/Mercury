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
    
    @AppStorage("noAppRefresh")
    var noAppRefresh = false       // default
    
    print("Scheduling... for \(refreshInterval) seconds")
    
    BGTaskScheduler.shared.getPendingTaskRequests { (tasks) in
        let isTaskPending = tasks.contains(where: { $0.identifier == "com.manorajesh.MercuryApp.updateLocation" })
        print("\(tasks.debugDescription)")
        
        if !isTaskPending && !noAppRefresh {
            let request = BGAppRefreshTaskRequest(identifier: "com.manorajesh.MercuryApp.updateLocation")
            request.earliestBeginDate = .now.addingTimeInterval(refreshInterval)
            
            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Unable to submit background process: \(error)")
            }
            print("Scheduled New Task")
        } else if noAppRefresh {
            BGTaskScheduler.shared.cancelAllTaskRequests()
            print("Refreshes are User disabled")
        } else {
            print("Already scheduled")
        }
    }
}
