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
        .backgroundTask(.appRefresh("LocationRefresh")) {
            scheduleAppRefresh()
            let context = await dataController.container.newBackgroundContext()
            let locationDataManager = LocationDataManager()
            context.automaticallyMergesChangesFromParent = true
            
            context.performAndWait {
                do {
                    let location = Coordinates(context: context)
                    location.id = UUID()
                    location.timestamp = Date()
                    location.latitude = (locationDataManager.locationManager.location?.coordinate.latitude)!
                    location.longitude = (locationDataManager.locationManager.location?.coordinate.longitude)!
                    print("\(location.latitude), \(location.longitude)")
                    try context.save()
                } catch {
                    print("Error with background task")
                }
            }
        }
    }
}
    
    func scheduleAppRefresh() {
        let refreshInterval = UserDefaults.standard.integer(forKey: "refreshInterval")
        
        let request = BGAppRefreshTaskRequest(identifier: "LocationRefresh")
        request.earliestBeginDate = Calendar.current.date(byAdding: .minute, value: 1, to: .now)
        try? BGTaskScheduler.shared.submit(request)
    }
