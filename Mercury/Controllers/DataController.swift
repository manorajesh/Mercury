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
}

func importData(from url: URL, moc: NSManagedObjectContext) {
    guard url.startAccessingSecurityScopedResource() else {
            // If the resource cannot be accessed, you should inform the user and return.
            print("Failed to access resource.")
            return
        }
        
        defer {
            url.stopAccessingSecurityScopedResource()
        }
    
    //        guard let importDataJSON = try? Data(contentsOf: url),
    //              let importData = try? JSONSerialization.jsonObject(with: importDataJSON, options: []) as? [[String: Any]] else {
    //            return
    //        }
    
    do {
        let importDataJSON = try Data(contentsOf: url)
        let importData = try JSONSerialization.jsonObject(with: importDataJSON, options: []) as? [[String: Any]]
        
        print(importData!.count)
        print(importData!.debugDescription)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        for coordinateData in importData! {
            let coordinate = Coordinates(context: moc)
            coordinate.id = UUID(uuidString: coordinateData["id"] as! String) ?? UUID()
            coordinate.timestamp = dateFormatter.date(from: coordinateData["timestamp"] as! String) ?? Date()
            coordinate.latitude = coordinateData["latitude"] as? Double ?? 0.0
            coordinate.longitude = coordinateData["longitude"] as? Double ?? 0.0
        }
        
        do {
            try moc.save()
        } catch {
            print(error)
        }
        
    } catch {
        print(error.localizedDescription)
    }
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
