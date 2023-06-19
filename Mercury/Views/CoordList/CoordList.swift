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
    
    @State private var isSuccess = false
    @State private var isError = false
    
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
            .navigationBarTitle("My Crumbs")
            .toast(isPresenting: $isError) {
                AlertToast(displayMode: .hud, type: .error(.red), title: "An error occured")
            }
            .toast(isPresenting: $isSuccess) {
                AlertToast(displayMode: .hud, type: .complete(.green), title: "Done!")
            }
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
        location.latitude = locationDataManager.locationManager.location!.coordinate.latitude
        location.longitude = locationDataManager.locationManager.location!.coordinate.longitude
        location.altitude = locationDataManager.locationManager.location!.altitude
        location.course = locationDataManager.locationManager.location!.course
        location.speed = locationDataManager.locationManager.location!.speed
        location.manualAdd = true
        print("\(location.latitude), \(location.longitude)")
        do {
            try moc.save()
            isSuccess.toggle()
        } catch {
            isError.toggle()
        }
    }
    
    func removeLocation(at offsets: IndexSet) {
        for index in offsets {
            let coordinate = coordinates[index]
            moc.delete(coordinate)
        }
        
        do {
            try moc.save()
            isSuccess.toggle()
        } catch {
            isError.toggle()
        }
    }
}


struct CoordList_Previews: PreviewProvider {
    static var previews: some View {
        Text("Unnecessary")
    }
}
