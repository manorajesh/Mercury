//
//  RowDetail.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/15/23.
//

import SwiftUI
import CoreLocation
import MapKit
import Contacts

struct RowDetail: View {
    var coordinate: Coordinates
    @State private var cityName = "Loading..."
    @State private var stateName = ""
    @State private var everythingName = ""
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        @State var lat_long = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        VStack {
            ZStack(alignment: .topTrailing) {
                Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: [coordinate],
                    annotationContent: { location in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), tint: .red)
                }
                )
                .onAppear {
                    setRegion(lat_long, &region)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                .frame(height: 250.0)
                .blur(radius: 10)
                
                Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: [coordinate],
                    annotationContent: { location in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), tint: .red)
                }
                )
                .onAppear {
                    setRegion(lat_long, &region)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                .frame(height: 250.0)
                
                VStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 2.0)) {
                            // Reset the region to your desired location
                            self.region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                            )
                        }
                    }) {
                        Image(systemName: "location.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.blue)
                                            .padding()
                                            .background(Color.gray)
                                            .clipShape(Circle())
                                            .padding(.all, 10)
                    }
                    .padding(.bottom)
                }
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
                            everythingName = CNPostalAddressFormatter.string(from: placemark.postalAddress!, style: .mailingAddress)
                        }
                    }
                }
            })
            .padding()
            
            VStack(alignment: .leading) {
                List {
                    Section {
                        Text("\(coordinate.latitude) \(coordinate.longitude)")
                    } header: {
                        Text("Coordinates")
                    }
                    Section {
                        Text("\(coordinate.timestamp?.formatted() ?? "Unknown Time Stamp")")
                    } header: {
                        Text("Time")
                    }
                    Section {
                        //                        Text(everythingName.isEmpty ? "Unknown Address" : everythingName)
                        Text(everythingName)
                    } header: {
                        Text("Address")
                    }
                    Section {
                        Text("\(coordinate.id?.uuidString ?? "Unknown")")
                    } header: {
                        Text("ID")
                    } footer: {
                        Text("Internal representation of location entry")
                    }
                }
                .textSelection(.enabled)
            }
        }
        .navigationTitle(cityName)
        Spacer()
    }
}

struct RowDetail_Previews: PreviewProvider {
    static var previews: some View {
        RowDetail(coordinate: Coordinates())
    }
}
