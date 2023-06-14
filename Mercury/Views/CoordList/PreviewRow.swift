//
//  PreviewRow.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/14/23.
//

import SwiftUI
import MapKit
import CoreLocation

struct PreviewRow: View {
    var coordinate: CLLocationCoordinate2D
    @State private var cityName = "Loading..."
    @State private var stateName = ""
    
    var body: some View {
        HStack {
            CircleMapPreivew(coordinate: coordinate)
                .frame(width: 100.0, height: 100.0)
                .padding()
            
            VStack(alignment: .leading) {
                Text(cityName)
                    .font(.title)
                Text(stateName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .onAppear(perform: {
                let geocoder = CLGeocoder()
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    if let error = error {
                        print("We have an error: \(error.localizedDescription)")
                    } else {
                        if let placemark = placemarks?[0] {
                            cityName = placemark.locality ?? "Unknown"
                            stateName = placemark.administrativeArea ?? "Unknown"
                        }
                    }
                }
            })
            
            Spacer()
        }
    }
}

struct PreviewRow_Previews: PreviewProvider {
    static var previews: some View {
        PreviewRow(coordinate: CLLocationCoordinate2D(latitude: 36, longitude: -106))
    }
}