//
//  CoordList.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/14/23.
//

import SwiftUI
import MapKit

struct CoordList: View {
    @StateObject var locationDataManager = LocationDataManager()
    @FetchRequest(sortDescriptors: []) var coordinates: FetchedResults<Coordinates>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    let location = Coordinates(context: moc)
                    location.id = UUID()
                    location.timestamp = Date()
                    location.latitude = (locationDataManager.locationManager.location?.coordinate.latitude.magnitude)!
                    location.longitude = (locationDataManager.locationManager.location?.coordinate.longitude.magnitude)!
                    try? moc.save()
                } label: {
                    Label("Add Current Location", systemImage: "plus")
                }
                Spacer()
            }

            List {
                ForEach(coordinates) { coordinate in
                    PreviewRow(coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
                }
                .onDelete(perform: removeLocation)
            }
        }
        
    }
    
    func removeLocation(at offsets: IndexSet) {
        for index in offsets {
            let coordinate = coordinates[index]
            moc.delete(coordinate)
        }
        
        do {
            try moc.save()
        } catch {
            print("Unable to save locations")
        }
    }
}


struct CoordList_Previews: PreviewProvider {
    static var previews: some View {
        CoordList()
    }
}
