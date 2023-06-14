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
    var polyline: Polyline

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateOverlays(from: uiView)
    }

    private func updateOverlays(from mapView: MKMapView) {
        mapView.removeOverlays(mapView.overlays)
        let overlay = MKPolyline(coordinates: polyline.coordinates, count: polyline.coordinates.count)
        mapView.addOverlay(overlay)
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
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(polyline: Polyline(coordinates: [
            CLLocationCoordinate2D(latitude: 34.024212, longitude: -118.496475), // Santa Monica, CA
            CLLocationCoordinate2D(latitude: 34.420830, longitude: -119.698189), // Santa Barbara, CA
            CLLocationCoordinate2D(latitude: 34.274647, longitude: -119.229034), // Ventura, CA
            CLLocationCoordinate2D(latitude: 35.270378, longitude: -120.680656), // San Luis Obispo, CA
            CLLocationCoordinate2D(latitude: 35.646328, longitude: -121.190536), // San Simeon, CA
            CLLocationCoordinate2D(latitude: 35.6852, longitude: -121.1666),     // Hearst Castle, CA
            CLLocationCoordinate2D(latitude: 36.491508, longitude: -121.197243)  // Pinnacles National Park, CA
        ]))
        .ignoresSafeArea(.all)
    }
}
