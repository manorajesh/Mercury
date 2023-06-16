//
//  AppDelegate.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/15/23.
//

import Foundation
import UIKit
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    let dataController = DataController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Registering...")
        registerProcessingRequest()
        print("Registered")
        return true
    }
    
    func registerProcessingRequest() {
        print("in function")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.manorajesh.MercuryApp.updateLocationProcessing", using: nil) { task in
            self.dataController.fetchLocation(task: task as! BGAppRefreshTask)
        }
    }
}
