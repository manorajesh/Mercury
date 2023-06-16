//
//  MapView.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/13/23.
//

import SwiftUI
import MapKit

struct Polyline: Identifiable {
    let id = UUID()
    let coordinates: [CLLocationCoordinate2D]
}

struct MapView: UIViewRepresentable {
    var coordinates: FetchedResults<Coordinates>

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        mapView.isUserInteractionEnabled = true
        mapView.selectableMapFeatures = .pointsOfInterest
        mapView.showsCompass = true
        mapView.showsScale = true
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateOverlays(from: uiView)
    }

    private func updateOverlays(from mapView: MKMapView) {
        let polylines = coordinates.map { coordinate in
            CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        mapView.removeOverlays(mapView.overlays)
        
        // polyline
        let lines = MKPolyline(coordinates: polylines, count: polylines.count)
        mapView.addOverlay(lines)
        
        // dots
        for coordinate in coordinates {
            let dot = MKPointAnnotation()
            dot.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            mapView.addAnnotation(dot)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
            //Set image
            annotationView.image = UIImage(named: "circle")
            
            return annotationView
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        Text("f")
    }
}
