//
//  LocationSearchTable.swift
//  My Simple App
//
//  Created by Samuel Folledo on 3/2/21.
//  Copyright © 2021 Erick Sanchez. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
    
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tableView.register(LocationSearchCell.self, forCellReuseIdentifier: String(describing: LocationSearchCell.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        let streetNumber = selectedItem.subThoroughfare
        let streetName = selectedItem.thoroughfare
        let cityName = selectedItem.locality
        let countyName = selectedItem.subAdministrativeArea
        let stateName = selectedItem.administrativeArea
        // put a space between streetNumber and streetName
        let firstSpace = streetNumber != nil &&
                            streetName != nil ? " " : ""
        // put a comma between street and city/state
        let comma = (streetNumber != nil || streetName != nil) &&
                    (selectedItem.subAdministrativeArea != nil || cityName != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (countyName != nil &&
                            stateName != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard //let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        //request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = Array(NSOrderedSet(array: response.mapItems)) as! [MKMapItem] //filter duplicates
            self.tableView.reloadData()
        }
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LocationSearchCell.self), for: indexPath) as! LocationSearchCell
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        print("Selected item is \(selectedItem)")
        dismiss(animated: true, completion: nil)
    }
}
