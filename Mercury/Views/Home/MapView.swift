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
        let overlay = MKPolyline(coordinates: polylines, count: polylines.count)
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
        Text("f")
    }
}
