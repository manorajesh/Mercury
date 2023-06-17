//
//  AppDelegate.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/15/23.
//

import Foundation
import UIKit
import BackgroundTasks
import MapKit

class AppDelegate: NSObject, UIApplicationDelegate {
    let dataController = DataController()
    var locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Registering...")
        registerAppRefreshRequest()
        print("Registered")
        return true
    }
    
    func registerAppRefreshRequest() {
        print("in function")
        BGTaskScheduler.shared.cancelAllTaskRequests()
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.manorajesh.MercuryApp.updateLocation", using: nil) { task in
            self.dataController.fetchLocation(task: task as! BGAppRefreshTask)
        }
    }
}
