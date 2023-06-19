//
//  ContentView.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/13/23.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct ContentView: View {
    @StateObject var locationDataManager = LocationDataManager()
    @State private var mapView = MKMapView()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var coordinates: FetchedResults<Coordinates>

    @State private var isUnlocked = false // defaults to unlocked
    
    @AppStorage("useLA")
    var useLA = false
    
    var body: some View {
        Group {
            if !useLA || isUnlocked {
                TabView {
                    ZStack(alignment: .topTrailing) {
                        MapView(mapView: $mapView, coordinates: coordinates)
                            .ignoresSafeArea(.container, edges: .all)
                        VStack {
                            UserTrackingButton(mapView: $mapView)
                                .frame(width: 40.0, height: 40.0)
                            CompassButton(mapView: $mapView)
                                .frame(width: 40.0, height: 40.0)
                        }
                        .padding()
                    }
                    .tabItem {
                        Image(systemName: "globe.americas.fill")
                            .resizable()
                        Text("Map")
                    }
                    .overlay(alignment: .top) {
                            Color.clear // Or any view or color
                                .background(.ultraThinMaterial)
                                .ignoresSafeArea(edges: .top)
                                .frame(height: 0) // This will constrain the overlay to only go above the top safe area and not under.
                                .blur(radius: 10.0)
                        }
                    
                    VStack {
                        switch locationDataManager.locationManager.authorizationStatus {
                        case .authorizedAlways:
                            CoordList(coordinates: coordinates)
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
                        Text("Crumbs")
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
            } else {
                VStack {
                    Text("Location Data is Locked")
                    Button {
                        authenticate()
                    } label: {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.red)
                            .padding()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.regular)
                }
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        if !useLA {
            return
        }
        let context = LAContext()
        
        let reason = "The location data is locked"
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            if success {
                withAnimation {
                    isUnlocked = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
