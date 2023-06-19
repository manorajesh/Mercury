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

struct UserTrackingButton: UIViewRepresentable {
    @Binding var mapView: MKMapView

    func makeUIView(context: Context) -> MKUserTrackingButton {
        let button = MKUserTrackingButton(mapView: mapView)
        button.backgroundColor = .white.withAlphaComponent(0.8)
        button.layer.cornerRadius = 5
        return button
    }

    func updateUIView(_ uiView: MKUserTrackingButton, context: Context) {}
}

struct CompassButton: UIViewRepresentable {
    @Binding var mapView: MKMapView

    func makeUIView(context: Context) -> MKCompassButton {
        let compass = MKCompassButton(mapView: mapView)
        return compass
    }

    func updateUIView(_ uiView: MKCompassButton, context: Context) {}
}

struct MapView: UIViewRepresentable {
    @Binding var mapView: MKMapView
    var coordinates: FetchedResults<Coordinates>
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        mapView.isUserInteractionEnabled = true
        mapView.selectableMapFeatures = .pointsOfInterest
        mapView.showsCompass = false
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
                renderer.lineWidth = 1
                renderer.lineDashPattern = [0, 5]
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        Text("f")
    }
}
