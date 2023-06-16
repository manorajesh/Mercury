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
    @FetchRequest(sortDescriptors: []) var coordinates: FetchedResults<Coordinates>
    
    var body: some View {
        TabView {
            MapView(coordinates: coordinates)
                .ignoresSafeArea(.container, edges: .all)
                .tabItem {
                    Image(systemName: "globe.americas.fill")
                        .resizable()
                    Text("My Map")
                }
            
            VStack {
                switch locationDataManager.locationManager.authorizationStatus {
                case .authorizedAlways:
                    CoordList()
                case .notDetermined:
                    VStack {
                        Text("Waiting for Location Access")
                        ProgressView()
                    }
                case .authorizedWhenInUse:
                    VStack {
                        Text("Automatic Location Access is Disabled")
                        ProgressView()
                    }
                default:
                    VStack {
                        Text("Location Access not Available")
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .tabItem {
                Image(systemName: "magazine")
                    .resizable()
                Text("My Locations")
            }
            
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                        .resizable()
                    Text("Settings")
                }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
