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
import SwiftUI

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
        @AppStorage("appRefreshes")
        var appRefreshes = 0 // default
        
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
        
        appRefreshes += 1
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
    
    func exportData(_ coordinates: FetchedResults<Coordinates>) -> URL? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let exportData: [[String: Any]] = coordinates.map { coordinate in
            [
                "id": coordinate.id?.uuidString ?? UUID().uuidString,
                "timestamp": dateFormatter.string(from: coordinate.timestamp ?? Date()),
                "latitude": coordinate.latitude,
                "longitude": coordinate.longitude
            ]
        }

        guard let exportDataJSON = try? JSONSerialization.data(withJSONObject: exportData, options: []) else {
            return nil
        }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("export.json")
        try? exportDataJSON.write(to: url)
        return url
    }
    
    func importData(from url: URL) {
        guard let importDataJSON = try? Data(contentsOf: url),
              let importData = try? JSONSerialization.jsonObject(with: importDataJSON, options: []) as? [[String: Any]] else {
            return
        }

        let moc = container.newBackgroundContext()
        importData.forEach { coordinateData in
            let coordinate = Coordinates(context: moc)
            coordinate.id = coordinateData["id"] as? UUID ?? UUID()
            coordinate.timestamp = coordinateData["timestamp"] as? Date ?? Date()
            coordinate.latitude = coordinateData["latitude"] as? Double ?? 0.0
            coordinate.longitude = coordinateData["longitude"] as? Double ?? 0.0
        }

        try? moc.save()
    }

}
