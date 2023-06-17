//
//  CircleImage.swift
//  Landmarks
//
//  Created by Mano Rajesh on 6/13/23.
//

import SwiftUI
import MapKit

struct StaticMapPreview: View {
    var coordinate: CLLocationCoordinate2D
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
            } else {
                EmptyView()
            }
        }
        .onAppear {
            getSnapshot(coordinate) { img in
                self.image = img
            }
        }
    }
}

struct StaticMapPreview_Previews: PreviewProvider {
    static var previews: some View {
        StaticMapPreview(coordinate: CLLocationCoordinate2D(latitude: 23, longitude: 43))
    }
}

func setRegion(_ coordinate: CLLocationCoordinate2D, _ region: inout MKCoordinateRegion) {
    region = MKCoordinateRegion(
        center: coordinate,
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
}

func getSnapshot(_ coordinate: CLLocationCoordinate2D, completion: @escaping (UIImage?) -> Void) {
    let options: MKMapSnapshotter.Options = .init()
    options.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    options.size = CGSize(width: 400.0, height: 200.0)
    options.showsBuildings = true
    options.mapType = .standard
    
    let snapshotter = MKMapSnapshotter(options: options)
    snapshotter.start { snapshot, error in
        if let error = error {
            print("Snapshot error: \(error)")
        }
        completion(snapshot?.image)
    }
}
