//
//  CircleImage.swift
//  Landmarks
//
//  Created by Mano Rajesh on 6/13/23.
//

import SwiftUI
import MapKit

struct CircleMapPreivew: View {
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        Map(coordinateRegion: $region)
            .onAppear {
                setRegion(coordinate, &region)
            }
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.gray, lineWidth: 2)
            }
            .shadow(radius: 7)
    }
}

struct CircleMapPreivew_Previews: PreviewProvider {
    static var previews: some View {
        CircleMapPreivew(coordinate: CLLocationCoordinate2D(latitude: 23, longitude: 43))
    }
}

func setRegion(_ coordinate: CLLocationCoordinate2D, _ region: inout MKCoordinateRegion) {
    region = MKCoordinateRegion(
        center: coordinate,
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
}
