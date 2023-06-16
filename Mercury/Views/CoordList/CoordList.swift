//
//  CoordList.swift
//  Mercury
//
//  Created by Mano Rajesh on 6/14/23.
//

import SwiftUI
import MapKit

struct CoordList: View {
    var coordinates: FetchedResults<Coordinates>
    @StateObject var locationDataManager = LocationDataManager()
    @Environment(\.managedObjectContext) var moc
    
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        NavigationView {
            Group {
                if coordinates.isEmpty {
                    VStack {
                        Text("Get started by adding your current location")
                            .padding()
                        Button {
                            onAdd()
                        } label: {
                            Label("Add Current Location", systemImage: "plus")
                        }
                    }
                } else {
                    List {
                        ForEach(coordinates) { coordinate in
                            NavigationLink {
                                RowDetail(coordinate: coordinate)
                            } label: {
                                PreviewRow(coordinate: coordinate)
                            }
                        }
                        .onDelete(perform: removeLocation)
                    }
                    .navigationBarItems(leading: EditButton(), trailing: addButton)
                    .environment(\.editMode, $editMode)
                }
            }
            .navigationBarTitle("My Locations")
        }
    }
    
    private var addButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
        default:
            return AnyView(EmptyView())
        }
    }
    
    func onAdd() {
        let location = Coordinates(context: moc)
        location.id = UUID()
        location.timestamp = Date()
        location.latitude = (locationDataManager.locationManager.location?.coordinate.latitude)!
        location.longitude = (locationDataManager.locationManager.location?.coordinate.longitude)!
        print("\(location.latitude), \(location.longitude)")
        try? moc.save()
    }
    
    func removeLocation(at offsets: IndexSet) {
        for index in offsets {
            let coordinate = coordinates[index]
            moc.delete(coordinate)
        }
        
        try? moc.save()
    }
}


struct CoordList_Previews: PreviewProvider {
    static var previews: some View {
//        CoordList(coordinates: FetchedResults<Coordinates>)
        Text("Unnecessary")
    }
}
