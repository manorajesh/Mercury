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
        // This is your background task
        // Fetch the location and save it to CoreData
        if let location = locationManager.location {
            saveLocation(location)
        }
        
        task.setTaskCompleted(success: true)
    }
    
    func saveLocation(_ location: CLLocation) {
        // Implement this method to save the location into CoreData
    }
}
