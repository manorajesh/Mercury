//
//  MercuryApp.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/13/23.
//

import SwiftUI
import BackgroundTasks
import CoreLocation

@main
struct MercuryApp: App {
    @StateObject private var dataController = DataController()
    let locationManager = CLLocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .onAppear(perform: setUp)
        }
    }
    
    func setUp() {
        print("Background task is set up")
        locationManager.delegate = dataController
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.manorajesh.MercuryApp.updateLocation",
            using: nil
        ) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        scheduleAppRefresh()
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.manorajesh.MercuryApp.updateLocation")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60) // Fetch every 2 minutes
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        print("Background task is running")
        scheduleAppRefresh()
        dataController.fetchLocation(task: task)
    }
}
