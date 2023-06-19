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
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        @State var lat_long = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)

        
        if verticalSizeClass == .regular {
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

                    Button(action: {
                        withAnimation(.easeInOut(duration: 2.0)) {
                            setRegion(lat_long, &region)
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                            .padding(.all, 5)
                    }
                    .padding(.bottom)
                    .padding(.all, 10)
                    .controlSize(.small)
                    .foregroundColor(.secondary)
                    .buttonBorderShape(.roundedRectangle(radius: 5.0))
                    .buttonStyle(.bordered)
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
                                everythingName = CNPostalAddressFormatter.string(from: placemark.postalAddress ?? CNPostalAddress(), style: .mailingAddress)
                            }
                        }
                    }
                })
                .padding()

                VStack(alignment: .leading) {
                    List {
                        Section {
                            Text("\(coordinate.latitude) \(coordinate.longitude)")
                                .font(.system(.body, design: .monospaced))
                        } header: {
                            Text("Coordinates")
                        }
                        Section {
                            Text("\(coordinate.timestamp?.formatted() ?? "Unknown Time Stamp")")
                        } header: {
                            Text("Time")
                        }
                        Section {
                            everythingName != "" ? Text(everythingName) : Text("Unavailable").foregroundColor(.gray)
                        } header: {
                            Text("Address")
                        }
                        Section {
                            Text("\(String(format: "%.2f", coordinate.altitude)) m")
                        } header: {
                            Text("Altitude")
                        }
                        Section {
                            coordinate.course > 0 ? Text("\(coordinate.course) m/s") : Text("Unavailable").foregroundColor(.gray)
                        } header: {
                            Text("Course")
                        }
                        Section {
                            coordinate.speed > 0 ? Text("\(coordinate.speed) m/s") : Text("Unavailable").foregroundColor(.gray)
                        } header: {
                            Text("Speed")
                        }
                        Section {
                            Text("\(coordinate.id?.uuidString ?? "Unknown")")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.gray)
                            
                            Text(coordinate.manualAdd ? "Manually Added" : "Added in Background")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.gray)
                        } header: {
                            SettingsHelp(title: "ID", alertTitle: "What is an ID?", alertText: "This is the internal identificaion of the location entry. It helps with sorting and managing similar location entries. You can ignore it")
                        } footer: {
                            Text("Internal representation of location entry")
                        }
                    }
                    .textSelection(.enabled)
                }
            }
            .navigationTitle(cityName)
            Spacer()
        } else {
            HStack {
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

                    Button(action: {
                        withAnimation(.easeInOut(duration: 2.0)) {
                            setRegion(lat_long, &region)
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                            .padding(.all, 5)
                    }
                    .padding(.bottom)
                    .padding(.all, 10)
                    .controlSize(.small)
                    .foregroundColor(.secondary)
                    .buttonBorderShape(.roundedRectangle(radius: 5.0))
                    .buttonStyle(.bordered)
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
                                everythingName = CNPostalAddressFormatter.string(from: placemark.postalAddress ?? CNPostalAddress(), style: .mailingAddress)
                            }
                        }
                    }
                })
                .padding()

                VStack(alignment: .leading) {
                    List {
                        Section {
                            Text("\(coordinate.latitude) \(coordinate.longitude)")
                                .font(.system(.body, design: .monospaced))
                        } header: {
                            Text("Coordinates")
                        }
                        Section {
                            Text("\(coordinate.timestamp?.formatted() ?? "Unknown Time Stamp")")
                        } header: {
                            Text("Time")
                        }
                        Section {
                            everythingName != "" ? Text(everythingName) : Text("Unavailable").foregroundColor(.gray)
                        } header: {
                            Text("Address")
                        }
                        Section {
                            Text("\(String(format: "%.2f", coordinate.altitude)) m")
                        } header: {
                            Text("Altitude")
                        }
                        Section {
                            coordinate.course > 0 ? Text("\(coordinate.course) m/s") : Text("Unavailable").foregroundColor(.gray)
                        } header: {
                            Text("Course")
                        }
                        Section {
                            coordinate.speed > 0 ? Text("\(coordinate.speed) m/s") : Text("Unavailable").foregroundColor(.gray)
                        } header: {
                            Text("Speed")
                        }
                        Section {
                            Text("\(coordinate.id?.uuidString ?? "Unknown")")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.gray)
                        } header: {
                            SettingsHelp(title: "ID", alertTitle: "What is an ID?", alertText: "This is the internal identificaion of the location entry. It helps with sorting and managing similar location entries. You can ignore it")
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
}

struct RowDetail_Previews: PreviewProvider {
    static var previews: some View {
        RowDetail(coordinate: Coordinates())
    }
}
