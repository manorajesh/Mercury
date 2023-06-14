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
        MapView(polyline: Polyline(coordinates: []))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
