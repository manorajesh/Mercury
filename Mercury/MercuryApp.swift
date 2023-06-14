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
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
        .backgroundTask(.appRefresh("ThirtyMinutesLater")) {
            
        }
    }
}

func scheduleAppRefresh() {
    let now = Date()
    let later = Calendar.current.date(byAdding: .minute, value: 30, to: now)
    
    let request = BGAppRefreshTaskRequest(identifier: "ThirtyMinutesLater")
    request.earliestBeginDate = later
    try? BGTaskScheduler.shared.submit(request)
}
