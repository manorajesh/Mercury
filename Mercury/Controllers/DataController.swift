//
//  DataController.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/14/23.
//

import Foundation
import CoreData
import MapKit
import BackgroundTasks

class DataController: NSObject, ObservableObject, CLLocationManagerDelegate {
    let container = NSPersistentContainer(name: "Mercury")
    let locationManager = CLLocationManager()
    
    override init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle location updates
        guard let location = locations.first else { return }
        
        // Save location into CoreData
        saveLocation(location)
    }
    
    func fetchLocation(task: BGAppRefreshTask) {
        print("In fetchLocation")
        
        // Set the expiration handler
        task.expirationHandler = {
            // This block will be called when your task is about to be terminated.
            // You should stop any work you are doing and save state if needed.
            print("Task expired")
            task.setTaskCompleted(success: false)
        }
        
        // Fetch the location and save it to CoreData
        if let location = locationManager.location {
            saveLocation(location)
            task.setTaskCompleted(success: true)
        } else {
            // If location is not available, you can complete the task with success: false
            task.setTaskCompleted(success: false)
        }
        scheduleAppRefreshRequest()
    }
    
    func saveLocation(_ location: CLLocation) {
        let moc = container.newBackgroundContext()
        
        let coordinate = Coordinates(context: moc)
        coordinate.id = UUID()
        coordinate.timestamp = Date()
        coordinate.latitude = location.coordinate.latitude
        coordinate.longitude = location.coordinate.longitude
        
        try? moc.save()
        print("Location Saved")
    }
}
