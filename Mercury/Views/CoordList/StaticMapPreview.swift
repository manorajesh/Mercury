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
        VStack {
            if let image = image {
                Color.clear
                    .overlay (
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    )
            } else {
                ProgressView()
            }
        }
        .onAppear {
            let options: MKMapSnapshotter.Options = .init()
            options.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            options.size = CGSize(width: 400.0, height: 200.0)
            options.showsBuildings = true
            options.mapType = .standard
            
            let snapshotter = MKMapSnapshotter(options: options)
            snapshotter.start { snapshot, error in
                if let snapshot = snapshot {
                    withAnimation(.spring()) {
                        image = snapshot.image
                    }
                } else if let error = error {
                    print("Something went wrong \(error.localizedDescription)")
                }
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
