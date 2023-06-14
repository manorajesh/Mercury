//
//  ContentView.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/13/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var locationDataManager = LocationDataManager()
    var body: some View {
        VStack {
            switch locationDataManager.locationManager.authorizationStatus {
            case .authorizedAlways:  // Location services are available.
                // Insert code here of what should happen when Location services are authorized
//                Text("Your current location is:")
//                Text("Latitude: \(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
//                Text("Longitude: \(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")
                let longitude = locationDataManager.locationManager.location?.coordinate.longitude.magnitude
                let latitude = locationDataManager.locationManager.location?.coordinate.latitude.magnitude
                MapView(polyline: Polyline(coordinates: [
                    CLLocationCoordinate2D(latitude: 26.0, longitude: -106.0),
                    CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                ]))
            case .authorizedWhenInUse:
                Text("Current location data is only when app is open")
                
            case .restricted, .denied:  // Location services currently unavailable.
                // Insert code here of what should happen when Location services are NOT authorized
                Text("Current location data was restricted or denied.")
            case .notDetermined:        // Authorization not determined yet.
                Text("Finding your location...")
                ProgressView()
            default:
                ProgressView()
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
